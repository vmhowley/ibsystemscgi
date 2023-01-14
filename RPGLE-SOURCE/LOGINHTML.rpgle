**free
    Ctl-opt BNDDIR('YAJL') option(*SRCSTMT);

        /include YAJL_H
          Dcl-C UpperCase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' ;
          Dcl-C LowerCase 'abcdefghijklmnopqrstuvwxyz' ;
          Dcl-C CRLF       x'0d25';
          Dcl-S Data       Char(65535);
          Dcl-S rdData     Char(65535);
          Dcl-S options    varChar(100)inz;
          Dcl-S Url        Char(1000) inz;
          Dcl-S myDate       Date;
          Dcl-S Parm       Char(100) inz;
          Dcl-S Parm1       Char(100) inz;
          Dcl-S usr        Char(10) inz;
          Dcl-S pwd        Char(10) inz;
          Dcl-S TOKEN      Char(20);

          dcl-pr Authuser extpgm ;
            FUSER char(10) ;
            FPASS char(10) ;
            FAUTH IND;
            FTKN CHAR(20);
            fmsg  char(50);
         end-pr ;



          dcl-s AuthFlag   Ind;
          dcl-s Message    Char(50);
          Dcl-S Pos        int(10);
          Dcl-S Posy        int(10);
          Dcl-S Len        int(10);


          Dcl-s RtnBuffer Char(4096)Inz;
          Dcl-s RtnLen     Int(10);
          Dcl-s nRtBufLen  int(10);

//ESCRIBIR A LA WEB
           Dcl-PR WriteToWeb  ExtProc('QtmhWrStout');
            DataVar     Char(65535) Options(*Varsize);
            DataVarLen  Int(10)     Const;
            ErrorCode   Char(8000)  Options(*Varsize);
           End-Pr;
//leer Data desde POST
           Dcl-pr ReadFromWeb  ExtProc('QtmhRdStin');
            szRtnBuffer Char(65535) Options(*Varsize);
            nBufLen     Int(10)     Const;
            nRtnLen     Int(10);
            Errorcod    Char(8000)  Options(*Varsize);
           End-Pr;
//obtener variables del entorno
           Dcl-PR GetEnv       pointer   ExtProc('getenv');
           Var                 pointer   value Options(*string);
           End-Pr;

            dcl-s Length int(10) ;
            dcl-s Data1 char(5000) ;
            dcl-s Array char(100) dim(20) ;
            dcl-s Element packed(3) ;
            dcl-s Start packed(3) ;
            dcl-s End like(Start) ;
            Dcl-s ReqMethod   Char(20);
            Dcl-s EBCData    char(32766) inz;

            dcl-pr Translate  ExtPgm('QDCXLATE');
              *N  packed(5:0) const;
              *N  char(32766) Options(*varsize);
              *N  char(10)    const;
           end-pr;


           dcl-ds cliente qualified;
           name   varchar(10);
           last   varchar(10);
           age    int(10);
           end-ds;


           Dcl-Ds     apiError    QUALIFIED;
            byteProv  Int(10)inz(0);
            byteAvail Int(10)inz(0);
           End-Ds;
        //------------ALL DATA STRUCTURES------------------
           Dcl-Ds     ErrDs       QUALIFIED;
            byteProv  Int(10)inz(0);
            byteAvail Int(10)inz(0);
           End-Ds;

           Dcl-s jsonErr    varchar(500)INZ('');
           Dcl-s docNode      like(yajl_val);
           Dcl-s node         like(yajl_val);
           Dcl-s nameNode     like(yajl_val);
           Dcl-s list         like(yajl_val);
           Dcl-s val          like(yajl_val);

           Dcl-s i            int(10);
           Dcl-s j            int(10);
           Dcl-s ValNum       packed(5);
           Dcl-s ValStr       char(50);
           Dcl-s Key       varchar(50);

            Parm   = 'username=';
            parm1  = 'password=';

            Data ='Content-type: TEXT/plain'+CRLF +CRLF ;

            WriteToWeb(Data: %len(%trim(Data)): ErrDs);

            ReadFromWeb(rtnBuffer: %size(rtnBuffer): rtnlen : apierror);
            EBCDATA = RTNBUFFER;
            Translate(%len(%trim(EBCData)): EBCData: 'QTCPEBC');
            RTNBUFFER = EBCDATA;


            //   'user=benito&pass=contra'
            //leer nombre de empleado
            //--------------------------------------------------------
        docNode = yajl_buf_load_tree(%addr(RTNBUFFER):%len(%trim(RTNBUFFER)):jsonErr);



        if jsonErr = '';
        node = yajl_object_find( docNode: 'username' );
        usr = yajl_get_string(Node);

        node = yajl_object_find( docNode: 'password' );
        pwd = yajl_get_string(Node);

        node = yajl_object_find( docNode: 'token' );
        TOKEN = yajl_get_string(Node);


        yajl_tree_free(docNode);

        if (usr <>'' and pwd <> '');

          callp authuser(usr:pwd:authflag:TOKEN:message);

if authflag=*on;
          data = '{"success":true,' +
                  '"message":"'+%trim(message)+'"}';
            else;
            data = '{"success":false,' +
                  '"message":"'+%trim(message)+'"}';
              endif;
              endif;
              endif;
             WriteToWeb(data : %len(%Trimr(data)): ErrDs);
data='';

            *Inlr = *On;
               Return;
