  MEMBER('WebCompressor.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('WebCompressor_BC0.CLW')
WebCompressor_BC0:DctInit             PROCEDURE()
WebCompressor_BC0:DctKill             PROCEDURE()
WebCompressor_BC0:FilesInit           PROCEDURE()
    END
  END

DctInit PROCEDURE()
  CODE
  WebCompressor_BC0:DctInit
  WebCompressor_BC0:FilesInit


DctKill PROCEDURE()
  CODE
  WebCompressor_BC0:DctKill

