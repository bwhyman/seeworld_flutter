import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeworld_flutter/components/logger_utils.dart';
import 'package:seeworld_flutter/controller/book_controller.dart';
import 'package:seeworld_flutter/provider/appbar_provider.dart';
import 'package:seeworld_flutter/provider/dialog_provider.dart';
import 'package:seeworld_flutter/provider/ocr_provider.dart';
import 'package:seeworld_flutter/provider/tts_provider.dart';
import 'package:seeworld_flutter/screens/reading/camera_chapter_screen.dart';

class ChapterScreen extends StatefulWidget {
  static const name = '/ChapterScreen';

  const ChapterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final AppBarProvider _appBarProvider = Get.put(AppBarProvider());
  final DialogProvider _dialogController = Get.put(DialogProvider());
  final BookController _bookController = Get.put(BookController());
  final OcrProvider _ocrProvider = Get.put(OcrProvider());
  final TextEditingController _editingController = TextEditingController();
  final TtsProvider _ttsProvider = Get.put(TtsProvider());
  late Chapter _chapter;
  bool _isEdit = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _chapter = ModalRoute.of(context)!.settings.arguments as Chapter;
    _ttsProvider.speakContent(_chapter.content ?? '');
    List<IconButton> items = [
      _appBarProvider.getIconButton(
          !_isEdit ? Icons.edit_note_outlined : Icons.edit_off_outlined,
          onPressed: () {
        _isEdit = !_isEdit;
        _editingController.value =
            _editingController.value.copyWith(text: _chapter.content);
        setState(() {});
      })
    ];
    if (_isEdit) {
      _ttsProvider.getTts().stop();
      items.add(_appBarProvider.getIconButton(Icons.document_scanner_outlined,
          onPressed: _camera));
    }

    return Scaffold(
      appBar:
          _appBarProvider.getTitleAppbar(_chapter.title ?? '', items: items),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: !_isEdit
            ? ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    _chapter.content ?? '',
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              )
            : Column(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 18),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _editingController,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          _updateChapter();
                        },
                        child: const Text('保存')),
                  ),
                ],
              ),
      ),
    );
  }

  _camera() async {
    _ttsProvider.getTts().stop();
    var imagePath = await Get.toNamed(CameraChapterScreen.name);
    _dialogController.showFullDialog('');
    String result = await _ocrProvider.send(imagePath);
    String r = _editingController.value.text + result;
    _editingController.value = _editingController.value.copyWith(text: r);
    _chapter.content = _editingController.value.text;
    Get.back();
    setState(() {});
    _ttsProvider.speakContent(_chapter.content ?? '');
  }

  _updateChapter() {
    _ttsProvider.speakContent(_chapter.content ?? '');
    _bookController.updateChapter(_chapter);
    _isEdit = false;
    setState(() {});
  }

  @override
  void dispose() {
    _editingController.dispose();
    _ttsProvider.getTts().stop();
    super.dispose();
  }
}
