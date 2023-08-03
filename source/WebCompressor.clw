   PROGRAM


StringTheory:TemplateVersion equate('3.61')
ResizeAndSplit:TemplateVersion equate('5.10')
OddJob:TemplateVersion equate('1.45')
WinEvent:TemplateVersion      equate('5.36')

   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE
  include('StringTheory.Inc'),ONCE
  include('ResizeAndSplit.Inc'),ONCE
  include('OddJob.Inc'),ONCE
    Include('WinEvent.Inc'),Once

   MAP
     MODULE('WEBCOMPRESSOR_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('WEBCOMPRESSOR001.CLW')
Main                   PROCEDURE   !
     END
       MyOKToEndSessionHandler(long pLogoff),long,pascal
       MyEndSessionHandler(long pLogoff),pascal
   END

  include('StringTheory.Inc'),ONCE
Glo:st               StringTheory
ThreadQ              QUEUE,PRE(Thrds)
ThreadNo               LONG
                     END
SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
Projects             FILE,DRIVER('TOPSPEED'),NAME('Projects.tps'),PRE(Pro),CREATE,BINDABLE,THREAD !                     
PKProjGuidKey            KEY(Pro:PKGuid),NOCASE,PRIMARY    !                     
Record                   RECORD,PRE()
PKGuid                      STRING(16)                     !                     
Description                 STRING(100)                    !                     
SourceJavascript            STRING(255)                    !                     
SourceCSS                   STRING(255)                    !                     
JavascriptDestination       STRING(255)                    !                     
CSSDestination              STRING(255)                    !                     
JavascriptGzipDestination   STRING(255)                    !                     
                         END
                     END                       

!endregion

WE::MustClose       long
WE::CantCloseNow    long
Access:Projects      &FileManager,THREAD                   ! FileManager for Projects
Relate:Projects      &RelationManager,THREAD               ! RelationManager for Projects

FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
GlobalErrorStatus    ErrorStatusClass,THREAD
GlobalErrors         ErrorClass                            ! Global error manager
INIMgr               INIClass                              ! Global non-volatile storage manager
GlobalRequest        BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE(0),THREAD                        ! Set to the response from the form
VCRRequest           LONG(0),THREAD                        ! Set to the request from the VCR buttons

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
  GlobalErrors.Init(GlobalErrorStatus)
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  INIMgr.Init('.\WebCompressor.INI', NVD_INI)              ! Configure INIManager to use INI file
  DctInit()
  SYSTEM{PROP:Icon} = 'AppIcon.ico'
    ds_SetOKToEndSessionHandler(address(MyOKToEndSessionHandler))
    ds_SetEndSessionHandler(address(MyEndSessionHandler))
  Main
  INIMgr.Update
  INIMgr.Kill                                              ! Destroy INI manager
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher
    
! ------ winevent -------------------------------------------------------------------
MyOKToEndSessionHandler procedure(long pLogoff)
OKToEndSession    long(TRUE)
! Setting the return value OKToEndSession = FALSE
! will tell windows not to shutdown / logoff now.
! If parameter pLogoff = TRUE if the user is logging off.

  code
  return(OKToEndSession)

! ------ winevent -------------------------------------------------------------------
MyEndSessionHandler procedure(long pLogoff)
! If parameter pLogoff = TRUE if the user is logging off.

  code


Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()

