program Jvcldemo;

uses
  Forms,
  Unitmain in 'Unitmain.pas' {Mainform},
  JvFormsU in 'JvFormsU.pas' {JvFormsFrm: TFrame},
  JvAnimatedTitelform in 'JvAnimatedTitelform.pas' {frAnimatedTitel},
  JvPerforatedform in 'JvPerforatedform.pas' {frPerforatedForm},
  JvTransparentFormd in 'JvTransparentFormd.pas' {frTransparentForm},
  Jvanimatedformicondemo in 'Jvanimatedformicondemo.pas' {frAnimatedFormIcon},
  Jvanimatedappicondemo in 'Jvanimatedappicondemo.pas' {frAnimatedApplicationicon},
  JvFormplacedemo in 'JvFormplacedemo.pas' {frFormplace},
  JvFormanimationdemo in 'JvFormanimationdemo.pas' {frFormAnimation},
  JvAutosizeformdemo in 'JvAutosizeformdemo.pas' {frAutosize},
  JvMagnetformdemo in 'JvMagnetformdemo.pas' {frmagnet},
  JvGradientformdemo in 'JvGradientformdemo.pas' {frgradient},
  JvDialogsU in 'JvDialogsU.pas' {JvDialogsFrm: TFrame},
  JvEditsU in 'JvEditsU.pas' {JvEditsFrm: TFrame},
  JvChoosersU in 'JvChoosersU.pas' {JvChoosersFrm: TFrame},
  FileListBoxMainFormU in '..\JvFileListBox\FileListBoxMainFormU.pas' {FileListBoxMainForm: TFrame},
  JvUtilsU in 'JvUtilsU.pas' {JvUtilsFrm: TFrame},
  JvPanelsU in 'JvPanelsU.pas' {JvPanelsFrm: TFrame},
  JvDateTimeU in 'JvDateTimeU.pas' {JvDateTimeFrm: TFrame},
  JvControlsU in 'JvControlsU.pas' {JvControls: TFrame},
  hello in 'hello.pas' {WelcomeForm: TFrame},
  JvZoomMainFormU in '..\JvZoom\JvZoomMainFormU.pas' {JvZoomMainForm},
  ContentScrollerMainFormU in '..\JvContentScroller\ContentScrollerMainFormU.pas' {ContentScrollerMainForm},
  JvButtonsU in 'JvButtonsU.pas' {JvButtons: TFrame},
  JvDBDateTimePickerMainFormU in '..\JvDBDateTimePicker\JvDBDateTimePickerMainFormU.pas' {JvDBDateTimePickerMainForm},
  JvFrameEmpty in 'JvFrameEmpty.pas' {frEmpty: TFrame},
  ListCombMainFormU in '..\JvListComb\ListCombMainFormU.pas' {ListCombMainForm},
  JvTrayIconDemo in 'JvTrayIconDemo.pas' {frTrayicon},
  JvTreeViewAsMenuMainFormU in '..\JvTreeViewAsMenu\JvTreeViewAsMenuMainFormU.pas' {JvTreeViewAsMenuMainForm},
  JvWallpaperform in 'JvWallpaperform.pas' {frWallpaper},
  JvWinDialogsU in 'JvWinDialogsU.pas' {JvWinDialogs: TFrame},
  ArrowButtonMainFormU in '..\JvArrowButton\ArrowButtonMainFormU.pas' {ArrowButtonMainForm},
//  BmpAnimMainFormU in '..\JvBitmapAnimator\BmpAnimMainFormU.pas' {BmpAnimMainForm},
//  ChangeNotificationMainFormU in '..\JvChangeNotification\ChangeNotificationMainFormU.pas' {ChangeNotificationMainForm},
//  ChangeNotificationDirDlgU in '..\JvChangeNotification\ChangeNotificationDirDlgU.pas' {ChangeNotificationDirDlg},
  JvAniMainFormU in '..\JvAni\JvAniMainFormU.pas' {JvAniMainForm},
  JvDataEmbeddedMainFormU in '..\JvDataEmbedded\JvDataEmbeddedMainFormU.pas' {JvDataEmbeddedMainForm},
//  JvMousePositionnerMainFormU in '..\JvMousePositionner\JvMousePositionnerMainFormU.pas' {JvMousePositionnerMainForm},
  MonthCalendarMainFormU in '..\JvMonthCalendar\MonthCalendarMainFormU.pas' {MonthCalendarMainForm},
//  MailExampleMainFormU in '..\JvMailExample\MailExampleMainFormU.pas' {MailExampleMainForm},
//  OLBarMainFormU in '..\JvOoutlookBar\OLBarMainFormU.pas' {OLBarMainForm},
  JvSearchFileMainFormU in '..\JvSearchFile\JvSearchFileMainFormU.pas' {JvSearchFileMainForm},
  JvNTEventLogMainFormU in '..\JvNTEventLog\JvNTEventLogMainFormU.pas' {JvNTEventLogMainForm},
  JvMruListMainFormU in '..\JvMruList\JvMruListMainFormU.pas' {JvMruListMainForm},
  JvLogFileMainFormU in '..\JvLogFile\JvLogFileMainFormU.pas' {JvLogFileMainForm},
  InstallLabelMainFormU in '..\JvInstallLabel\InstallLabelMainFormU.pas' {InstallLabelMainForm},
//  JvAppHotKeyDemoMainFormU in '..\JvAppHotKeyDemo\JvAppHotKeyDemoMainFormU.pas' {JvAppHotKeyDemoMainForm},
  JvBrowseFolderMainFormU in '..\JvBrowseFolder\JvBrowseFolderMainFormU.pas' {JvBrowseFolderMainForm},
//  CreateProcessExampleMainFormU in '..\JvCreateProcessExample\CreateProcessExampleMainFormU.pas' {CreateProcessExampleMainForm},
  JvClipboardViewerMainFormU in '..\JvClipboardViewer\JvClipboardViewerMainFormU.pas' {JvClipboardViewerMainForm},
  JvSpecialProgressMainFormU in '..\JvSpecialProgress\JvSpecialProgressMainFormU.pas' {JvSpecialProgressMainForm},
//  JvColorComboDemoMainFormU in '..\JvColorComboDemo\JvColorComboDemoMainFormU.pas' {JvColorComboDemoMainForm},
//  JvInspectorDBDemoMainFormU in '..\JvInspectorDBDemo\JvInspectorDBDemoMainFormU.pas' {JvInspectorDBDemoMainForm},
  JvWindowsTitleMainFomU in '..\JvWindowsTitle\JvWindowsTitleMainFomU.pas' {JvWindowsTitleMainForm},
  RaHtHintsMainFormU in '..\RALib\RaHtHints\RaHtHintsMainFormU.pas' {RaHtHintsMainForm},
//  ControlsExampleMainFormU in '..\JvControlsExample\ControlsExampleMainFormU.pas' {ControlsExampleMainForm},
  JvBalloonHintMainFormU in '..\JvBalloonHint\JvBalloonHintMainFormU.pas' {JvBalloonHintMainForm},
  OtherStandAlone in 'OtherStandAlone.pas' {OtherMainForm},
//  DSADialogsMainFormU in '..\JvDSADialogs\JvDSADialogsMainFormU.pas' {DSADialogsMainForm},
//  MessageDlgEditorSelectIcon in '..\JvDSADialogs\JvMessageDlgEditorSelectIcon.pas' {frmMessageDlgEditorSelectIcon},
//  DSAExamplesCustom2 in '..\JvDSADialogs\JvDSAExamplesCustom2.pas' {frmDSAExamplesCustomDlg2},
//  DSAExamplesProgressDlg in '..\JvDSADialogs\JvDSAExamplesProgressDlg.pas' {frmDSAExamplesProgressDlg},

//  MessageDlgEditorMain in '..\JvDSADialogs\JvMessageDlgEditorMain.pas' {frmMessageDlgEditor},
//  DSAExamplesCustom1 in '..\JvDSADialogs\JvDSAExamplesCustom1.pas' {frmDSAExamplesCustomDlg1},
  JvHTMLParserMainFormU in '..\JvHTMLParser\JvHTMLParserMainFormU.pas' {JvHTMLParserMainForm},
  JvLinkLabelMainFormU in '..\JvLinkLabel\JvLinkLabelMainFormU.pas' {JvLinkLabelMainForm},
  CategCh in '..\JvLinkLabel\CategCh.pas',
  InfoStrings in '..\JvLinkLabel\InfoStrings.pas',
  Play in '..\JvLinkLabel\Play.pas' {frmPlay},
  JvScreenCaptureMainFormU in '..\JvScreenCapture\JvScreenCaptureMainFormU.pas' {JvScreenCaptureMainForm},
//  JvShellHookDemoMainFormU in '..\JvShellHookDemo\JvShellHookDemoMainFormU.pas' {JvShellHookDemoMainForm},
  JvShFileOperationMainFormU in '..\JvShFileOperation\JvShFileOperationMainFormU.pas' {JvShFileOperationMainForm},
  JvSystemPopup2MainFormU in '..\JvSystemPopUp2\JvSystemPopup2MainFormU.pas' {JvSystemPopup2MainForm},
  JvSystemPopupMainFormU in '..\JvSystemPopup\JvSystemPopupMainFormU.pas' {JvSystemPopupMainForm},
  JvThumbnailMainFormU in '..\JvThumbnail\JvThumbnailMainFormU.pas' {JvThumbnailMainForm},
  JvThumbnailChildFormU in '..\JvThumbnail\JvThumbnailChildFormU.pas' {JvThumbnailChildForm},
  JvTranslatorMainFormU in '..\JvTranslator\JvTranslatorMainFormU.pas' {JvTranslatorMainForm},
//  JvWndProcHookDemoMainFormU in '..\JvWndProcHookDemo\JvWndProcHookDemoMainFormU.pas' {JvWndProcHookDemoMainForm},
  RegTVMainFormU in '..\JvRegistryTreeView\RegTVMainFormU.pas' {RegTVMainForm},
  InfoFrm in '..\JvRunDll32\InfoFrm.pas' {frmInfo},
  RunDll32MainFormU in '..\JvRunDll32\RunDll32MainFormU.pas' {RunDll32MainForm},
//  ScrollWinMainFormU in '..\JvScrollWin\ScrollWinMainFormU.pas' {JvScrollingWindowMainForm},
  TimelineNotesFormU in '..\JvTimeline\TimelineNotesFormU.pas' {TimelineNotesForm},
  TimelineMainFormU in '..\JvTimeline\TimelineMainFormU.pas' {TimelineMainForm},
  TipOfDayMainFormU in '..\JvTipOfDay\TipOfDayMainFormU.pas' {TipOfDayMainForm},
  TMTimeLineMainFormU in '..\JvTMTimeLine\TMTimeLineMainFormU.pas' {TMTimeLineMainForm},
  frmMemoEdit in '..\JvTMTimeLine\frmMemoEdit.pas' {MemoEditFrm},
//  TransBtnFormMainU in '..\JvTransBtn\TransBtnFormMainU.pas' {TransBtnFormMain},
  JvZLibMultipleMainFormU in '..\JvZLibMultiple\JvZLibMultipleMainFormU.pas' {JvZLibMultipleMainForm},
  Profiler32MainFormU in '..\JvProfiler32\Profiler32MainFormU.pas' {Profiler32MainForm},
  FindReplaceMainFormU in '..\JvFindReplace\FindReplaceMainFormU.pas' {FindReplaceMainForm},
  JvPlayListMainFormU in '..\JvPlayList\JvPlayListMainFormU.pas' {JvPlaylistMainForm},
  RessourcesFormMain in 'RessourcesFormMain.pas' {RessourcesForm},
  SearchingForm in 'SearchingForm.pas' {SearchingFormMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Jvcl MegaDemo';
  Application.HelpFile := '';
  Application.CreateForm(TMainform, Mainform);
  Application.Run;
end.
