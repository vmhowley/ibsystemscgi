**free
         Ctl-opt Dftactgrp(*no)  Actgrp(*new) option(*SRCSTMT);

           Dcl-pr GetProf         ExtPgm('QSYGETPH');
             UId         char(10)const;
             Pwd         char(10)const;
             Handle      Char(12);
             ErDs        like(erds);
             PwdLength   int(10)options(*nopass);
             CCSID       int(10)options(*nopass);
            End-pr;
      //-----------------------Convert to Caps Variable----------------
              Dcl-c   Small           'abcdefghijklmnñopqrstuvwxyz';
              Dcl-c   Caps            'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ';
      //-----------------------Local Variables------------------------
              Dcl-s   Handler         Char(12)inz;
              Dcl-s   PwdLen          int(10)inz(0);
              Dcl-s   PwdCCSID        int(10)inz(0);
      //-----------------------Erro55DS------------------------------
           Dcl-ds  ErDs;
             BytesProvided   Int(10) Inz(%size(ErDs));
             BytesAvail      Int(10) Inz(0);
             ErrMsgId        Char(7);
             Reserved        Char(1);
             ErrMsg          Char(1024);
           end-ds;

          Dcl-Pi  *n;
            InpUser         Char(10);
            InpPassword     Char(10);
            AuthFlag        Ind;
            $TOKEN           CHAR(20);
            Message         Char(50);
          end-pi;

          //convertirg  user id to upper case
          InpUser =%XLATE(Small:Caps:InpUser);

          //Get length  of password
          PwdLen = %len(%trim(InpPassword));

          //Get the profile handler using userid and password
          GetProf(InpUser:InpPassword:Handler:erds:PwdLen:pwdCCSID);

         //If byteavail > 0  then some error
         if BytesAvail > 0;
          AuthFlag = *off;
              Select;
                  when ErrMsgId = 'CPF2203';
                      Message = 'User profile ' + %TRIM(InpUser) +' Not Correct.';
                  when ErrMsgId = 'CPF2204';
                      Message = 'User profile ' + %TRIM(InpUser) +' Not Foud.';
                  when ErrMsgId = 'CPF22E3';
                      Message = 'User profile ' + %TRIM(InpUser) +' Is Disable.';
                  when ErrMsgId = 'CPF22E2';
                      Message = ' Password not correct for user profile ' + %TRIM(InpUser);
                  Other;
                      Message = 'Failed with Message ID ' + %TRIM(ErrMsg);
              Endsl;
          else;
              AuthFlag = *On;
    clear message;
              Message = 'authenticated';
         Endif;
         *inlr = *on;
         Return;
