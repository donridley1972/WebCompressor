

   MEMBER('WebCompresspr.clw')                             ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('WEBCOMPRESSPR001.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('WEBCOMPRESSPR002.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('WEBCOMPRESSPR003.INC'),ONCE        !Req'd for module callout resolution
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
Main PROCEDURE 

x                   Long
CompressionStarted  BYTE
Ndx                 Long

MyState                     Long
MyState:NextJs              Equate(1)
MyState:NextCss             Equate(2)
MyState:WaitOnThreads       Equate(3)
abc                  STRING(20)                            ! 
DestCssQ             QUEUE,PRE(DestCss)                    ! 
name                 STRING(256)                           ! 
shortname            STRING(13)                            ! 
date                 LONG                                  ! 
time                 LONG                                  ! 
size                 LONG                                  ! 
attrib               BYTE                                  ! 
                     END                                   ! 
DestJsQ              QUEUE,PRE(DestJs)                     ! 
name                 STRING(256)                           ! 
shortname            STRING(13)                            ! 
date                 LONG                                  ! 
time                 LONG                                  ! 
size                 LONG                                  ! 
attrib               BYTE                                  ! 
                     END                                   ! 
SourceCssQ           QUEUE,PRE(SrcCss)                     ! 
name                 STRING(256)                           ! 
shortname            STRING(13)                            ! 
date                 LONG                                  ! 
time                 LONG                                  ! 
size                 LONG                                  ! 
attrib               BYTE                                  ! 
                     END                                   ! 
SourceJSQ            QUEUE,PRE(SrcJs)                      ! 
name                 STRING(256)                           ! 
shortname            STRING(13)                            ! 
date                 LONG                                  ! 
time                 LONG                                  ! 
size                 LONG                                  ! 
attrib               BYTE                                  ! 
                     END                                   ! 
BRW2::View:Browse    VIEW(Projects)
                       PROJECT(Pro:Description)
                       PROJECT(Pro:PKGuid)
                       PROJECT(Pro:SourceJavascript)
                       PROJECT(Pro:SourceCSS)
                       PROJECT(Pro:JavascriptDestination)
                       PROJECT(Pro:CSSDestination)
                       PROJECT(Pro:JavascriptGzipDestination)
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
Pro:Description        LIKE(Pro:Description)          !List box control field - type derived from field
Pro:PKGuid             LIKE(Pro:PKGuid)               !Browse hot field - type derived from field
Pro:SourceJavascript   LIKE(Pro:SourceJavascript)     !Browse hot field - type derived from field
Pro:SourceCSS          LIKE(Pro:SourceCSS)            !Browse hot field - type derived from field
Pro:JavascriptDestination LIKE(Pro:JavascriptDestination) !Browse hot field - type derived from field
Pro:CSSDestination     LIKE(Pro:CSSDestination)       !Browse hot field - type derived from field
Pro:JavascriptGzipDestination LIKE(Pro:JavascriptGzipDestination) !Browse hot field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
Window               WINDOW('WebCompressor'),AT(,,449,264),FONT('Segoe UI',10),RESIZE,AUTO,ICON('AppIcon.ico'), |
  GRAY,SYSTEM,TIMER(5),IMM
                       BUTTON,AT(427,242,20,15),USE(?Close),LEFT,ICON('Close1.ico')
                       IMAGE('Logo.png'),AT(2,1,260,45),USE(?IMAGE1)
                       SHEET,AT(2,49,445,190),USE(?SHEET1)
                         TAB('  General'),USE(?GeneralTab),FONT(,10),ICON('AppIcon.ico')
                           LIST,AT(9,66,87,152),USE(?List),LEFT(2),VSCROLL,FORMAT('400L(2)|M~Description~@s100@'),FROM(Queue:Browse), |
  IMM
                           BUTTON,AT(77,222,19,12),USE(?Delete),ICON('Delete1.ico')
                           BUTTON,AT(54,222,19,12),USE(?Change),ICON('Edit1.ico')
                           BUTTON,AT(31,222,19,12),USE(?Insert),ICON('Insert1.ico')
                           SHEET,AT(100,65,341,153),USE(?SHEET2)
                             TAB('Source'),USE(?SourceTab)
                               SHEET,AT(101,82,334,130),USE(?FilesSheet)
                                 TAB('Javascript Files'),USE(?SourceJavascriptTab)
                                   LIST,AT(107,99,319,106),USE(?SourceJavascriptList),HVSCROLL,FORMAT('1020L(2)|M~Files~@s255@'), |
  FROM(SourceJSQ)
                                 END
                                 TAB('CSS Files'),USE(?SourceCssTab)
                                   LIST,AT(107,99,319,106),USE(?SourceCssList),HVSCROLL,FORMAT('1020L(2)|M~Files~@s255@'),FROM(SourceCssQ)
                                 END
                               END
                             END
                             TAB('Destination'),USE(?TAB3)
                               SHEET,AT(101,82,334,130),USE(?DestinationFilesSheet)
                                 TAB('Javascript Files'),USE(?DestinationJavascriptTab)
                                   LIST,AT(107,99,319,106),USE(?DestinationJavascriptList),VSCROLL,FORMAT('1020L(2)|M~Files~@s255@'), |
  FROM(DestJsQ)
                                 END
                                 TAB('CSS Files'),USE(?DestinationCSSTab)
                                   LIST,AT(107,99,319,106),USE(?DestinationCSSList),HVSCROLL,FORMAT('1020L(2)|M~Files~@s255@'), |
  FROM(DestCssQ)
                                 END
                               END
                             END
                           END
                           BUTTON('Compress'),AT(390,219),USE(?CompressBtn)
                         END
                         TAB('  Settings'),USE(?SettingsTab),ICON('Settings1.ico')
                         END
                       END
                     END

    omit('***',WE::CantCloseNowSetHereDone=1)  !Getting Nested omit compile error, then uncheck the "Check for duplicate CantCloseNowSetHere variable declaration" in the WinEvent local template
WE::CantCloseNowSetHereDone equate(1)
WE::CantCloseNowSetHere     long
    !***
ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
! ----- csResize --------------------------------------------------------------------------
csResize             Class(csResizeClass)
    ! derived method declarations
Fetch                  PROCEDURE (STRING Sect,STRING Ent,*? Val),VIRTUAL
Update                 PROCEDURE (STRING Sect,STRING Ent,STRING Val),VIRTUAL
Init                   PROCEDURE (),VIRTUAL
                     End  ! csResize
! ----- end csResize -----------------------------------------------------------------------
BRW2                 CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
TakeNewSelection       PROCEDURE(),DERIVED
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

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Main')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Close
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:Projects.Open()                                   ! File Projects used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW2.Init(?List,Queue:Browse.ViewPosition,BRW2::View:Browse,Queue:Browse,Relate:Projects,SELF) ! Initialize the browse manager
  SELF.Open(Window)                                        ! Open window
  Do DefineListboxStyle
  Alert(AltKeyPressed)  ! WinEvent : These keys cause a program to crash on Windows 7 and Windows 10.
  Alert(F10Key)         !
  Alert(CtrlF10)        !
  Alert(ShiftF10)       !
  Alert(CtrlShiftF10)   !
  Alert(AltSpace)       !
  WinAlertMouseZoom()
  WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
  BRW2.Q &= Queue:Browse
  BRW2.AddSortOrder(,)                                     ! Add the sort order for  for sort order 1
  BRW2.AddField(Pro:Description,BRW2.Q.Pro:Description)    ! Field Pro:Description is a hot field or requires assignment from browse
  BRW2.AddField(Pro:PKGuid,BRW2.Q.Pro:PKGuid)              ! Field Pro:PKGuid is a hot field or requires assignment from browse
  BRW2.AddField(Pro:SourceJavascript,BRW2.Q.Pro:SourceJavascript) ! Field Pro:SourceJavascript is a hot field or requires assignment from browse
  BRW2.AddField(Pro:SourceCSS,BRW2.Q.Pro:SourceCSS)        ! Field Pro:SourceCSS is a hot field or requires assignment from browse
  BRW2.AddField(Pro:JavascriptDestination,BRW2.Q.Pro:JavascriptDestination) ! Field Pro:JavascriptDestination is a hot field or requires assignment from browse
  BRW2.AddField(Pro:CSSDestination,BRW2.Q.Pro:CSSDestination) ! Field Pro:CSSDestination is a hot field or requires assignment from browse
  BRW2.AddField(Pro:JavascriptGzipDestination,BRW2.Q.Pro:JavascriptGzipDestination) ! Field Pro:JavascriptGzipDestination is a hot field or requires assignment from browse
  csResize.Init('Main',Window,1)
  INIMgr.Fetch('Main',Window)                              ! Restore window settings from non-volatile store
  BRW2.AskProcedure = 1                                    ! Will call: UpdateProjects
  BRW2.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  csResize.Open()
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
    INIMgr.Update('Main',Window)                           ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    UpdateProjects
    ReturnValue = GlobalResponse
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
    CASE ACCEPTED()
    OF ?CompressBtn
      CompressionStarted = TRUE
      MyState = MyState:NextJs
      !      ds_Sleep(200)
      !      YIELD
      !      Loop x = 1 to Records(SourceJSQ)
      !        Get(SourceJSQ,x)
      !        Clear(ThreadQ)
      !        YIELD
      !        ThreadQ.ThreadNo = Start(Compress,,clip(Pro:SourceJavascript) & '\' & clip(SourceJSQ.name),Clip(Pro:JavascriptDestination) & '\' & Clip(SourceJSQ.name))
      !        Add(ThreadQ)      
      !        Resume(ThreadQ.ThreadNo)
      !        ds_sleep(5)
      !      
      !      End 
      !      YIELD
      !      Loop x = 1 to Records(SourceCssQ)
      !        Get(SourceCssQ,x)
      !        Clear(ThreadQ)
      !        YIELD
      !        ThreadQ.ThreadNo = Start(Compress,,clip(Pro:SourceCSS) & '\' & clip(SourceCssQ.name),Clip(Pro:CSSDestination) & '\' & Clip(SourceCssQ.name))
      !        Add(ThreadQ)
      !        Resume(ThreadQ.ThreadNo)
      !        ds_sleep(5)
      !      End 
      !Glo:st.FileNameOnly(Clip(SourceJSQ.name))
      
      !Message('Done!')
    END
  ReturnValue = PARENT.TakeAccepted()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  csResize.TakeEvent()
  LOOP                                                     ! This method receives all events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeEvent()
  !MyState                     Long
  !MyState:NextJs              Equate(1)
  !MyState:NextCss             Equate(2)  
    Case EVENT()
    Of EVENT:Timer
  
  
        Case MyState
        Of MyState:NextJs
            If Ndx = Records(SourceJSQ)
                Ndx = 0
                MyState = MyState:NextCss
            End
            ndx+=1
  
            Get(SourceJSQ,ndx)
            Clear(ThreadQ)
            YIELD
            ThreadQ.ThreadNo = Start(Compress,,clip(Pro:SourceJavascript) & '\' & clip(SourceJSQ.name),Clip(Pro:JavascriptDestination) & '\' & Clip(SourceJSQ.name))
            Add(ThreadQ)      
            Resume(ThreadQ.ThreadNo)
            !ds_sleep(5)
        Of MyState:NextCss
            If Ndx = Records(SourceJSQ)
                Ndx = 0
                MyState = MyState:WaitOnThreads
            End
            ndx+=1
            Get(SourceCssQ,Ndx)
            Clear(ThreadQ)
            YIELD
            ThreadQ.ThreadNo = Start(Compress,,clip(Pro:SourceCSS) & '\' & clip(SourceCssQ.name),Clip(Pro:CSSDestination) & '\' & Clip(SourceCssQ.name))
            Add(ThreadQ)
            Resume(ThreadQ.ThreadNo)
            ds_sleep(5)
        Of MyState:WaitOnThreads
            If CompressionStarted = TRUE
                If Records(ThreadQ) = 0
                    CompressionStarted = FALSE
                    MyState = 0
                    Message('Done!')
                END
            End      
        End
    End
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

!----------------------------------------------------
csResize.Fetch   PROCEDURE (STRING Sect,STRING Ent,*? Val)
  CODE
  INIMgr.Fetch(Sect,Ent,Val)
  PARENT.Fetch (Sect,Ent,Val)
!----------------------------------------------------
csResize.Update   PROCEDURE (STRING Sect,STRING Ent,STRING Val)
  CODE
  INIMgr.Update(Sect,Ent,Val)
  PARENT.Update (Sect,Ent,Val)
!----------------------------------------------------
csResize.Init   PROCEDURE ()
  CODE
  PARENT.Init ()
  Self.CornerStyle = Ras:CornerDots
  SELF.GrabCornerLines() !
  SELF.SetStrategy(?Close,100,100,0,0)
  SELF.SetStrategy(?SHEET1,0,0,100,100)
  SELF.SetStrategy(?List,,0,,100)
  SELF.SetStrategy(?Delete,,100,,0)
  SELF.SetStrategy(?Change,,100,,0)
  SELF.SetStrategy(?Insert,,100,,0)
  SELF.SetStrategy(?SHEET2,0,0,100,100)
  SELF.SetStrategy(?SourceJavascriptList,0,0,100,100)
  SELF.SetStrategy(?SourceCssList,0,0,100,100)
  SELF.SetStrategy(?DestinationFilesSheet,0,0,100,100)
  SELF.SetStrategy(?DestinationJavascriptList,0,0,100,100)
  SELF.SetStrategy(?DestinationCSSList,0,0,100,100)
  SELF.SetStrategy(?CompressBtn,100,100,0,0)

BRW2.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END


BRW2.TakeNewSelection PROCEDURE

  CODE
    glo:st.Trace('[Main][BRW2.TakeNewSelection]Pro:SourceJavascript[' & Clip(Pro:SourceJavascript) & ']')
    Free(SourceJSQ)
    Free(SourceCssQ)
    !DIRECTORY(SourceJSQ, Clip(Pro:SourceJavascript) * '\', ff_:NORMAL) 
    DIRECTORY(SourceJSQ, Clip(Pro:SourceJavascript) & '\*.js', ff_:NORMAL)
    DIRECTORY(SourceCssQ, Clip(Pro:SourceCSS) & '\*.css', ff_:NORMAL)
    !Message(Records(SourceJSQ))
    !DIRECTORY(SourceJSQ, '*.js', ff_:NORMAL)   
  PARENT.TakeNewSelection

