

   MEMBER('WebCompressor.clw')                             ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('WEBCOMPRESSOR002.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! Form Projects
!!! </summary>
UpdateProjects PROCEDURE 

CurrentTab           STRING(80)                            ! 
ActionMessage        CSTRING(40)                           ! 
History::Pro:Record  LIKE(Pro:RECORD),THREAD
QuickWindow          WINDOW('Form Projects'),AT(,,366,95),FONT('Segoe UI',10,,FONT:regular,CHARSET:DEFAULT),RESIZE, |
  AUTO,CENTER,ICON('AppIcon.ico'),GRAY,HLP('UpdateProjects'),SYSTEM,IMM
                       BUTTON('&OK'),AT(209,73,49,14),USE(?OK),LEFT,ICON('WAOK.ICO'),DEFAULT,FLAT,MSG('Accept dat' & |
  'a and close the window'),TIP('Accept data and close the window')
                       BUTTON('&Cancel'),AT(261,73,49,14),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),FLAT,MSG('Cancel operation'), |
  TIP('Cancel operation')
                       BUTTON('&Help'),AT(314,73,49,14),USE(?Help),LEFT,ICON('WAHELP.ICO'),FLAT,MSG('See Help Window'), |
  STD(STD:Help),TIP('See Help Window')
                       PROMPT('Description:'),AT(5,4),USE(?Pro:Description:Prompt),TRN
                       ENTRY(@s100),AT(121,4,226,10),USE(Pro:Description),LEFT(2)
                       PROMPT('Source Javascript:'),AT(5,19),USE(?Pro:SourceJavascript:Prompt),TRN
                       ENTRY(@s255),AT(121,19,226,10),USE(Pro:SourceJavascript),LEFT(2)
                       PROMPT('Source CSS:'),AT(5,33),USE(?Pro:SourceCSS:Prompt),TRN
                       ENTRY(@s255),AT(121,33,226,10),USE(Pro:SourceCSS),LEFT(2)
                       PROMPT('Javascript Destination:'),AT(5,47),USE(?Pro:JavascriptDestination:Prompt),TRN
                       ENTRY(@s255),AT(121,47,226,10),USE(Pro:JavascriptDestination),LEFT(2)
                       PROMPT('CSS Destination:'),AT(5,60),USE(?Pro:CSSDestination:Prompt),TRN
                       ENTRY(@s255),AT(121,60,226,10),USE(Pro:CSSDestination),LEFT(2)
                       BUTTON,AT(351,19,12,11),USE(?LookupFile),ICON('Search1.ico')
                       BUTTON,AT(351,33,12,11),USE(?LookupFile:2),ICON('Search1.ico')
                       BUTTON,AT(351,47,12,11),USE(?LookupFile:3),ICON('Search1.ico')
                       BUTTON,AT(351,60,12,11),USE(?LookupFile:4),ICON('Search1.ico')
                     END

    omit('***',WE::CantCloseNowSetHereDone=1)  !Getting Nested omit compile error, then uncheck the "Check for duplicate CantCloseNowSetHere variable declaration" in the WinEvent local template
WE::CantCloseNowSetHereDone equate(1)
WE::CantCloseNowSetHere     long
    !***
ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

FileLookup7          SelectFileClass
FileLookup8          SelectFileClass
FileLookup9          SelectFileClass
FileLookup10         SelectFileClass
CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Record Will Be Added'
  OF ChangeRecord
    ActionMessage = 'Record Will Be Changed'
  END
  QuickWindow{PROP:Text} = ActionMessage                   ! Display status message in title bar
  CASE SELF.Request
  OF ChangeRecord OROF DeleteRecord
    QuickWindow{PROP:Text} = QuickWindow{PROP:Text} & '  (' & Pro:Description & ')' ! Append status message to window title text
  OF InsertRecord
    QuickWindow{PROP:Text} = QuickWindow{PROP:Text} & '  (New)'
  END
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateProjects')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?OK
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(Pro:Record,History::Pro:Record)
  SELF.AddHistoryField(?Pro:Description,2)
  SELF.AddHistoryField(?Pro:SourceJavascript,3)
  SELF.AddHistoryField(?Pro:SourceCSS,4)
  SELF.AddHistoryField(?Pro:JavascriptDestination,5)
  SELF.AddHistoryField(?Pro:CSSDestination,6)
  SELF.AddUpdateFile(Access:Projects)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Projects.Open()                                   ! File Projects used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Projects
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.CancelAction = Cancel:Cancel+Cancel:Query         ! Confirm cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  Alert(AltKeyPressed)  ! WinEvent : These keys cause a program to crash on Windows 7 and Windows 10.
  Alert(F10Key)         !
  Alert(CtrlF10)        !
  Alert(ShiftF10)       !
  Alert(CtrlShiftF10)   !
  Alert(AltSpace)       !
  WinAlertMouseZoom()
  WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
  IF SELF.Request = ViewRecord                             ! Configure controls for View Only mode
    ?Pro:Description{PROP:ReadOnly} = True
    ?Pro:SourceJavascript{PROP:ReadOnly} = True
    ?Pro:SourceCSS{PROP:ReadOnly} = True
    ?Pro:JavascriptDestination{PROP:ReadOnly} = True
    ?Pro:CSSDestination{PROP:ReadOnly} = True
    DISABLE(?LookupFile)
    DISABLE(?LookupFile:2)
    DISABLE(?LookupFile:3)
    DISABLE(?LookupFile:4)
  END
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('UpdateProjects',QuickWindow)               ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  FileLookup7.Init
  FileLookup7.ClearOnCancel = True
  FileLookup7.Flags=BOR(FileLookup7.Flags,FILE:LongName)   ! Allow long filenames
  FileLookup7.Flags=BOR(FileLookup7.Flags,FILE:Directory)  ! Allow Directory Dialog
  FileLookup7.SetMask('Javascript Files','*.js')           ! Set the file mask
  FileLookup7.WindowTitle='Source Javascript'
  FileLookup8.Init
  FileLookup8.ClearOnCancel = True
  FileLookup8.Flags=BOR(FileLookup8.Flags,FILE:LongName)   ! Allow long filenames
  FileLookup8.Flags=BOR(FileLookup8.Flags,FILE:Directory)  ! Allow Directory Dialog
  FileLookup8.SetMask('CSS Files','*.CSS')                 ! Set the file mask
  FileLookup8.WindowTitle='Source CSS'
  FileLookup9.Init
  FileLookup9.ClearOnCancel = True
  FileLookup9.Flags=BOR(FileLookup9.Flags,FILE:LongName)   ! Allow long filenames
  FileLookup9.Flags=BOR(FileLookup9.Flags,FILE:Directory)  ! Allow Directory Dialog
  FileLookup9.SetMask('All Files','*.*')                   ! Set the file mask
  FileLookup9.WindowTitle='Javascript Destination'
  FileLookup10.Init
  FileLookup10.ClearOnCancel = True
  FileLookup10.Flags=BOR(FileLookup10.Flags,FILE:LongName) ! Allow long filenames
  FileLookup10.Flags=BOR(FileLookup10.Flags,FILE:Directory) ! Allow Directory Dialog
  FileLookup10.SetMask('All Files','*.*')                  ! Set the file mask
  FileLookup10.WindowTitle='CSS Destination'
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  If self.opened Then WinAlert().
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Projects.Close()
  END
  IF SELF.Opened
    INIMgr.Update('UpdateProjects',QuickWindow)            ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    OF ?LookupFile
      ThisWindow.Update()
      Pro:SourceJavascript = FileLookup7.Ask(1)
      DISPLAY
    OF ?LookupFile:2
      ThisWindow.Update()
      Pro:SourceCSS = FileLookup8.Ask(1)
      DISPLAY
    OF ?LookupFile:3
      ThisWindow.Update()
      Pro:JavascriptDestination = FileLookup9.Ask(1)
      DISPLAY
    OF ?LookupFile:4
      ThisWindow.Update()
      Pro:CSSDestination = FileLookup10.Ask(1)
      DISPLAY
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeEvent()
  If event() = event:VisibleOnDesktop !or event() = event:moved
    ds_VisibleOnDesktop()
  end
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeWindowEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all window specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE EVENT()
    OF EVENT:CloseDown
      if WE::CantCloseNow
        WE::MustClose = 1
        cycle
      else
        self.CancelAction = cancel:cancel
        self.response = requestcancelled
      end
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:OpenWindow
        post(event:visibleondesktop)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

