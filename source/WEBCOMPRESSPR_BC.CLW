  MEMBER('WebCompresspr.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('WebCompresspr_BC0.CLW')
WebCompresspr_BC0:DctInit             PROCEDURE()
WebCompresspr_BC0:DctKill             PROCEDURE()
WebCompresspr_BC0:FilesInit           PROCEDURE()
    END
  END

DctInit PROCEDURE()
  CODE
  WebCompresspr_BC0:DctInit
  WebCompresspr_BC0:FilesInit


DctKill PROCEDURE()
  CODE
  WebCompresspr_BC0:DctKill

