

   MEMBER('WebCompresspr.clw')                             ! This is a MEMBER module

                     MAP
                       INCLUDE('WEBCOMPRESSPR003.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
Compress             PROCEDURE  (string pSource,string pDest) ! Declare Procedure
ExitCmd         Long
! ----- job --------------------------------------------------------------------------
job                  Class(JobObject)
                     End  ! job
! ----- end job -----------------------------------------------------------------------

  CODE
    !Glo:st.Trace('ajaxmin.exe "' & clip(pSource) & '" -o "' & clip(pDest) & '" -clobber:true')
    !Run('ajaxmin.exe -silent "' & clip(pSource) & '" -o "' & clip(pDest) & '" -clobber:true',1)
    YIELD

    !(string pAppName, ushort pMode, byte pUseCMD=0, <string pPath>, <string pMessage>, <string pTitle>,<*long pExitCommand>, <*StringTheory strData>, long noRead = 0, long noStore = 0)
    job.CreateProcess('ajaxmin.exe -silent "' & clip(pSource) & '" -o "' & clip(pDest) & '" -clobber:true',jo:SW_HIDE,0,Longpath(),'','',,,1,1)

    YIELD
    !if glo:st.ExtensionOnly(clip(pSource)) = 'js'
        job.CreateProcess('gzip -9 -n -f -c "' & clip(pSource) & '" > "' & clip(pDest) & '.gz"',jo:SW_HIDE,1,Longpath(),'','',,,1,1)
    !End
    ThreadQ.ThreadNo = Thread()
    Get(ThreadQ,ThreadQ.ThreadNo)
    Delete(ThreadQ)
