**free
//-------------------------------------------------------------------*
//Empresa. . . . . . : IB Systems S.A.                               *
//Sistema. . . . . . : Sistema de Administracion de Tarjeta          *
//Programa . . . . . : CONSUW001                                     *
//Descripcion. . . . : Consulta Alfabetica de Cliente                *
//Autor. . . . . . . : Staff IBSystems S.A.                          *
//Analista. . .  . . : VICTOR M HOWLEY.                              *
//Fecha Creacion . . : ENERO 11, 2022                                *
//-------------------------------------------------------------------*
Ctl-opt BNDDIR('QC2LE':'YAJL') DATFMT(*ISO)
     Dftactgrp(*no)  actgrp(*caller)    option(*SRCSTMT:*nodebugio);
Dcl-F SATMCLI02 Usage(*INPUT) Keyed;
Dcl-F SATMCLI03 Usage(*INPUT) Keyed;
Dcl-F satmtarw1 Usage(*INPUT) Keyed;
Dcl-F SATFLOT04 Usage(*INPUT) Keyed;
Dcl-F SATMCLI00 Usage(*INPUT) Keyed;
Dcl-F SATmtar01 Usage(*INPUT) Keyed;
Dcl-F SATmtar00 Usage(*INPUT) Keyed;
Dcl-F SATMSAL00 Usage(*INPUT) Keyed;
Dcl-F SATMSAL08 Usage(*INPUT) Keyed;
Dcl-F saumcta00 Usage(*INPUT) Keyed;

Dcl-PI *n;
  String         Char(1677310);
  par            CHAr(2);
  RESPONSE       CHAR(1677310);
End-PI;

Dcl-Ds     ErrDs       QUALIFIED;
 byteProv  Int(10)inz(0);
 byteAvail Int(10)inz(0);
End-Ds;
 /include YAJL_H

Dcl-C CRLF         x'0d25';
Dcl-s data         char(65535);
Dcl-s jsonErr      varchar(500)INZ('');
Dcl-s docNode      like(yajl_val);
Dcl-s node         like(yajl_val);
Dcl-s nameNode     like(yajl_val);
Dcl-s list         like(yajl_val);
Dcl-s val          like(yajl_val);
Dcl-s i            int(10);
Dcl-s j            int(10);
Dcl-s ValNum       ZONED(5);
Dcl-s ValStr       char(60);
Dcl-s Key          varchar(50);
Dcl-s command      char(50);
DCL-S Banco        char(3)inz('001');
DCL-S Cia          char(3)inz('001');
DCL-S CODBP        ZONED(3)inz(001);
DCL-S CODCP        ZONED(3)inz(001);

DCL-S Prefix       char(10);
DCL-S Codigo       char(20);
DCL-S Descrip      char(50);
Dcl-S opc          char(9);

dcl-s errors       zoned(4:0);

Dcl-C UpperCase 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' ;
Dcl-C LowerCase 'abcdefghijklmnopqrstuvwxyz';



dcl-pr Translate  ExtPgm('QDCXLATE');
     *N  packed(5:0) const;
     *N  char(65535) Options(*varsize);
     *N  char(10)    const;
end-pr;



Dcl-pr SATIDES01 extpgm;
   Banco       char(3);
   Cia         char(3);
   Prefix      char(10);
   Codigo      char(20);
   Descrip     char(50);
END-PR;

DCL-DS SATC0004FL EXT END-DS;

Dcl-pr SATC0004 extpgm('SATC0004');
   $CODBP_TCEBP      ZONED(3:0);
   $CODCP_TCEBP      ZONED(3:0);
   $DSC_COPRS        char(40);
   $DSC_DCEAP        char(40);
   $USRPAR_VAR       char(10);
   $NUM_CLIENTE      char(14);
   $NUM_TARJETA      zoned(16:0);
   $MONEDA           zoned(3:0);
   $IND              char(2);
   DS_WEB            LIKEDS(SATC0004FL);
END-PR;


dcl-s   numta           zoned(16:0);
DCL-S   DSC_COPRS        char(40);
DCL-S   DSC_DCEAP       char(40);
DCL-S   USRPAR_VAR      char(10);

DCL-S F01 ZONED(2:0);
DCL-S F02 CHAR(52);
Dcl-S TCACT char(16);
Dcl-S encrypted char(60);
Dcl-S tcusd      char(19);
Dcl-S codcl      CHAR(14);
Dcl-S moned      zoned(3:0);
Dcl-S monedA     CHAR(3);
Dcl-S nrid       int(5);
Dcl-S ids        char(15);
Dcl-S numta1     char(4);
Dcl-S numta2     char(2);
Dcl-S numta3     char(4);
Dcl-S numta4     char(4);
Dcl-S bin        char(6);
Dcl-S fecv1      char(2);
Dcl-S fecv2      char(2);
Dcl-S DEBITO     ZONED(12:2);
Dcl-S CREDITO    ZONED(12:2);
Dcl-S DB         char(16);
Dcl-S CR         char(16);
Dcl-S MONEDW     CHAR(3);
Dcl-S BUTTONS    CHAR(65535);


//------------PROCESO INICIAL

// parametro variable que contiene numero de cedula (string)"YAJL"
       docNode = yajl_buf_load_tree(%addr(STRING):%len(%trim(STRING)):jsonErr);

       if jsonErr = '';
        node = yajl_object_find( docNode: 'F01' );
        ValStr = yajl_get_string(Node);
        F01 = %DEC(valSTR:2:0);
         node = yajl_object_find( docNode: 'F02' );
         ValStr = yajl_get_string(Node);
         F02 = valSTR;
        yajl_tree_free(docNode);
//----------------------------------------------------------------------------------
endif;

IF par ='CO' AND F01 = 07;

    exsr consulta_cedula;

else;

if par ='CO' AND f01=10;

    exsr consulta_nombre;

else;

if par ='CO' AND f01=08;

    exsr consulta_tarjeta;

else;

//

if par ='VT';
    EXSR CLIENT_TC;
ELSE;

IF par ='TS';
    EXSR TCINF;
ELSE;


IF PAR ='SW';
EXSR TCSAL;
ELSE;

IF par ='SV';
    EXSR saldovenc;
else;
if par ='TR';
    EXSR saldovenctr;
ENDIF;
ENDIF;
ENDIF;
ENDIF;
ENDIF;
ENDIF;
ENDIF;
ENDIF;

         *INLR=*on;
         return;
//INICIO DE SUBRUTINAS PARA ENVIAR BLOQUE HTML (STRING) A SATWEB.PGM

begsr consulta_cedula;
CLEAR RESPONSE;
            SETLL (001:001:F02)   satmcli00;
            READE (001:001:F02)   satmcli00;

      IF  Not %EQUAL;


//RESPONSE de error para pagina html (cliente no encontrado, verifique)----------------
RESPONSE ='0001';
//---------------------------------------END--------------------------------------------------
    else;

//Busca descripcion de estado de tarjet---------------------------------------
RESPONSE ='<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="table-responsive">'+CRLF+
'<table  id="basic-datatable" class="table  table-sm dt-responsive nowrap w-100">'+crlf+
'<thead>'+crlf+
'<tr>'+crlf+
'           <th>Name</th>'+crlf+
'           <th>Gender</th>'+crlf+
'           <th>Birth Date</th>'+crlf+
'           <th>Client ID</th>'+crlf+
'           <th>Status</th>'+crlf+
'           <th>Action</th>'+crlf+
'       </tr>'+crlf+
'   </thead>'+crlf+
'   <tbody>'+crlf;

Dow not %Eof (SATMCLI03);
NRID += 1;
//Busca descripcion de estado de tarjet---------------------------------------
if stscl_mcli = 'A';
descrip = 'Activo';//A=Activo
opc = 'success';

else;

if stscl_mcli = 'I';
descrip = 'Inactivo';//I=Inactivo
opc = 'secondary';

endif;
endif;

//Bloque HTML cliente encontrado (DATOS DEL CLIENTE)
APEL2_MCLI = %XLATE('¥':'Ñ':APEL2_MCLI);
APEL1_MCLI = %XLATE('¥':'Ñ':APEL1_MCLI);

DATA = %TRIM(DATA) + '       <tr>'+crlf+
'           <td id="dataSelect'+%char(nrid)+'">'+%trim(Nomb1_mcli)+'&nbsp'+%trim(Nomb2_mcli)+'&nbsp'+
%trim(APEL1_MCLI)+'&nbsp'+%trim(APEL2_MCLI)+'</td>'+crlf+
'           <td>'+SEXCL_MCLI+'</td>'+crlf+
'           <td>'+%CHAR(%date(FECNA_MCLI:*ISO))+'</td>'+crlf+
'           <td id="codcl'+%char(nrid)+'">'+%char(CODCL_MCLI)+'</td>'+crlf+
'           <td><i class="mdi mdi-circle text-'+opc+'"></i>'+%trim(descrip)+'</td>'+crlf+
'           <td><button href="#" onclick="tcFunction(id)" id="'+%trim(%char(nrid))+'"'+
'class="btn btn-outline-warning" data-toggle="tooltip">Ver Tarjetas <i class="dripicons-card"></i></button>'+
'</td>'+crlf+
' </tr>'+crlf;



READE (001:001:F02)   satmcli03;

ENDDO;


RESPONSE = %TRIMr(RESPONSE) + %TRIMr(DATA) + '   </tbody>'+crlf+
'</table>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>';
endif;
endsr;


begsr consulta_nombre;
CLEAR RESPONSE;
F02= %XLATE(LOWERCASE: UPPERCASE: F02);
  SETLL (001:001:F02)   satmcli03;
  READE   (001:001:F02)  satmcli03;
  IF  Not %EQUAL;
//Error Response for html pages-------------
response = '0001';

  else;
RESPONSE ='<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="table-responsive">'+CRLF+
'<table  id="basic-datatable" class="table  table-sm dt-responsive nowrap w-100">'+crlf+
'<thead>'+crlf+
'<tr style="text-align:center">'+crlf+
'<th>Name</th>'+crlf+
'<th>Gender</th>'+crlf+
'<th>Birth Date</th>'+crlf+
'<th>Client ID</th>'+crlf+
'<th>Status</th>'+crlf+
'<th>Action</th>'+crlf+
'</tr>'+crlf+
'</thead>'+crlf+
'<tbody>'+crlf;

Dow NOT %EOF(SATMCLI03);

//Bloque HTML cliente encontrado (DATOS DEL CLIENTE)
APEL2_MCLI = %XLATE('¥':'Ñ':APEL2_MCLI);
APEL1_MCLI = %XLATE('¥':'Ñ':APEL1_MCLI);
NRID += 1;
//Busca descripcion de estado de tarjet---------------------------------------

if stscl_mcli = 'A';
descrip = 'Activo';//A=Activo
opc = 'success';

else;

descrip = 'Inactivo';//I=Inactivo
opc = 'secondary';
endif;

response = %TRIMR(response) + '<tr style="text-align:center">'+crlf+
'<td style="text-align:left" id="dataSelect'+%TRIMR(%char(nrid))+'">'+CRLF+
%trim(Nomb1_mcli)+'&nbsp'+%trim(Nomb2_mcli)+'&nbsp'+
%trim(APEL1_MCLI)+'&nbsp'+%trim(APEL2_MCLI)+'</td>'+crlf+
'<td>'+SEXCL_MCLI+'</td>'+crlf+
'<td>'+%CHAR(%date(FECNA_MCLI:*iso))+'</td>'+crlf+
'<td id="codcl'+%TRIM(%char(nrid))+'">'+
%TRIM(%char(CODCL_MCLI))+'</td>'+crlf+
'<td><i class="mdi mdi-circle text-'+
%TRIM(opc)+'"></i>'+%trim(descrip)+'</td>'+crlf+
'<td><button href="#" onclick="tcFunction(id)" id="'+
%trim(%char(nrid))+'"class="btn btn-outline-warning"'+
'data-toggle="tooltip">Ver Tarjetas <i class="dripicons-card"></i>'+
'</button>'+
'</td>'+crlf+
' </tr>'+crlf;
READE  (001:001:F02)  satmcli03;
ENDDO;
RESPONSE = %TRIM(RESPONSE)+
'</tbody>'+crlf+
'</table>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf;
endif;
endsr;

begsr consulta_tarjeta;
CLEAR RESPONSE;
monitor;
            sETLL (001:001:%dec(f02:16:0))   satmtar00;
            READE (001:001:%dec(f02:16:0))   satmtar00;
             ON-ERROR;
            response='002';
   endmon;
   IF  Not %EQUAL;

//RESPONSE de error para pagina html (cliente no encontrado, verifique)----------------
RESPONSE ='0002';
//---------------------------------------END--------------------------------------------------
ELSE;

            sETLL (001:001:codcl_mtar)   satmcli02;
            READE (001:001:codcl_mtar)   satmcli02;
NRID += 1;
RESPONSE ='<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="table-responsive">'+CRLF+
'<table  id="basic-datatable" class="table  table-sm dt-responsive nowrap w-100">'+crlf+
'<thead>'+crlf+
'<tr>'+crlf+
'           <th>Name</th>'+crlf+
'           <th>Gender</th>'+crlf+
'           <th>Birth Date</th>'+crlf+
'           <th>Client ID</th>'+crlf+
'           <th>Status</th>'+crlf+
'           <th>Action</th>'+crlf+
'       </tr>'+crlf+
'   </thead>'+crlf+
'   <tbody>'+crlf;

Dow not %Eof (SATMCLI02);

//Busca descripcion de estado de tarjet---------------------------------------
if stscl_mcli = 'A';
descrip = 'Activo';//A=Activo
opc = 'success';

else;

if stscl_mcli = 'I';
descrip = 'Inactivo';//I=Inactivo
opc = 'secondary';

endif;
endif;

//Bloque HTML cliente encontrado (DATOS DEL CLIENTE)

APEL2_MCLI = %XLATE('¥':'Ñ':APEL2_MCLI);
APEL1_MCLI = %XLATE('¥':'Ñ':APEL1_MCLI);

DATA = %TRIM(DATA) + '       <tr>'+crlf+
'           <td id="dataSelect'+%char(nrid)+'">'+%trim(Nomb1_mcli)+'&nbsp'+%trim(Nomb2_mcli)+'&nbsp'+
%trim(APEL1_MCLI)+'&nbsp'+%trim(APEL2_MCLI)+'</td>'+crlf+
'           <td>'+SEXCL_MCLI+'</td>'+crlf+
'           <td>'+%CHAR(%date(FECNA_MCLI:*iso))+'</td>'+crlf+
'           <td id="codcl'+%char(nrid)+'">'+%char(CODCL_MCLI)+'</td>'+crlf+
'           <td><i class="mdi mdi-circle text-'+opc+'"></i>'+%trim(descrip)+'</td>'+crlf+
'           <td><button href="#" onclick="tcFunction(id)" id="'+%trim(%char(nrid))+'"'+
'class="btn btn-outline-warning" data-toggle="tooltip">Ver Tarjetas <i class="dripicons-card"></i></button>'+
'</td>'+crlf+
' </tr>'+crlf;
READE (001:001:codcl_mtar)   satmcli02;
ENDDO;
RESPONSE = %TRIMr(RESPONSE) + %TRIMr(DATA) + '   </tbody>'+crlf+
'</table>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>';
endif;
endsr;

BEGSR CLIENT_TC;

clear nrid;

 SETLL (001:001:%dec(%trim(f02):14:0))   satmtar01;
 READE (001:001:%dec(f02:14:0))   satmtar01;

if not %Equal;
RESPONSE ='0002';

else;


Dow not %Eof (satmtar01);
IF tcact_mtar <> *zeros;
    fecv2  = %subst(%char(FVENC_MTAR):3:2);
    fecv1  = %subst(%char(FVENC_MTAR):5:2);
     EXSR tCenmasc;
 nrid += 1;
 ENDIF;
  tcact = %char(tcact_mtar);


data= %trim(data)+'<div class="col-md-6">'+crlf+
'<div class="card1">'+crlf+
'<input hidden id="colum'+%char(nrid)+'" value="'+%trim(numta1+numta2+numta4+%char(codcl_mtar))+'">'+
'</input>'+crlf+
'    <div onclick="tcSelect(id)" id="'+%char(nrid)+'" class="front">'+crlf+
'        <div class="strip-bottom"></div>'+crlf+
'        <div class="strip-top"></div>'+crlf+
'        <div class="investor">IBSYSTEMS</div>'+crlf+
'        <div class="chip">'+crlf+
'            <div class="chip-line"></div>'+crlf+
'            <div class="chip-line"></div>'+crlf+
'            <div class="chip-line"></div>'+crlf+
'            <div class="chip-line"></div>'+crlf+
'            <div class="chip-main"></div>'+crlf+
'        </div>'+crlf+
'        <svg class="wave" viewBox="0 3.71 26.959 38.787" width="26.959" height="38.787" fill="white">'+crlf+
'  <path d="M19.709 3.719c.266.043.5.187.656.406 4.125 5.207 6.594 11.781 6.594 18.938 0 7.156-2.469 '+
'13.73-6.594 18.937-.195.336-.57.531-.957.492a.9946.9946 0 0 1-.851-.66c-.129-.367-.035-.777.246-1.'+
'051 3.855-4.867 6.156-11.023 6.156-17.718 0-6.696-2.301-12.852-6.156-17.719-.262-.317-.301-.762-.'+
'102-1.121.204-.36.602-.559 1.008-.504z"></path>'+crlf+
'<path d="M13.74 7.563c.231.039.442.164.594.343 3.508 4.059 5.625 9.371 5.625 15.157 0 5.785-2.113 '+
'11.097-5.625 15.156-.363.422-1 .472-1.422.109-.422-.363-.472-1-.109-1.422 3.211-3.711 5.156-8.551'+
' 5.156-13.843 0-5.293-1.949-10.133-5.156-13.844-.27-.309-.324-.75-.141-1.114.188-.367.578-.582.985'+
'-.542h.093z"></path>'+crlf+
'<path d="M7.584 11.438c.227.031.438.144.594.312 2.953 2.863 4.781 6.875 4.781 11.313 0 4.433-1.828'+
' 8.449-4.781 11.312-.398.387-1.035.383-1.422-.016-.387-.398-.383-1.035.016-1.421 2.582-2.504 4.18'+
'7-5.993 4.187-9.875 0-3.883-1.605-7.372-4.187-9.875-.321-.282-.426-.739-.266-1.133.164-.395.559-'+
'.641.984-.617h.094zM1.178 15.531c.121.02.238.063.344.125 2.633 1.414 4.437 4.215 4.437 7.407 0 '+
'3.195-1.797 5.996-4.437 7.406-.492.258-1.102.07-1.36-.422-.257-.492-.07-1.102.422-1.359 2.012-1'+
'.075 3.375-3.176 3.375-5.625 0-2.446-1.371-4.551-3.375-5.625-.441-.204-.676-.692-.551-1.165.122'+
'-.468.567-.785 1.051-.742h.094z"></path>'+crlf+
'</svg>'+crlf+
'        <div class="card-number">'+crlf+
'            <div class="section">'+numta1+'</div>'+crlf+
'            <div class="section">'+numta2+'xx</div>'+crlf+
'            <div class="section">xxxx</div>'+crlf+
'            <div class="section">'+numta4+'</div>'+crlf+
'        </div>'+crlf+
'    <div class="end"><span class="end-text">exp. end:</span><span class="end-date">'+fecv1+'/'+fecv2+'</s'+
'pan></div>'+crlf+
'    <div class="card-holder">'+NOMPL_MTAR+' </div>'+crlf+
'        </div>'+crlf+
'        </div>'+crlf+
'    </div>'+crlf;
READE (001:001:%dec(%trim(f02):16:0))   satmtar01;

enddo;
RESPONSE ='<div class="card" id="simple-dragula" data-plugin="dragula" '+
'data-containers="["company-list-left", "company-list-right"]">'+crlf+
'<div class="card-body">'+crlf+
'<div class="card-widgets">'+crlf+
  '<a href="javascript:;" data-bs-toggle="reload"><i class="mdi mdi-refresh"></i></a>'+crlf+
  '<a id="minimicoll1" data-bs-toggle="collapse" href="#cardCollpase1" role="button" aria-expanded="fal'+
  'se" aria-controls="cardCollpase1"><i class="mdi mdi-minus"></i></a>'+crlf+
                '</div>'+crlf+
'<h5 class="card-title text-center">Tarjetas Del Cliente</h5>'+crlf+
'<div class="container collapse pt-3 show" id="cardCollpase1">'+crlf+
'<div class="row" >'+crlf+
%trim(data)+'</div>'+crlf+'</div>'+crlf+'</div>'+crlf+'</div>'+crlf;
ENDIF;
ENDSR;

begsr TCINF;

bin = %subst(f02:1:6);
numta4= %subst(f02:7:10);
codcl= %subst(f02:11:24);

chain (001:001:%DEC(codcl:14:0):bin:numta4) satmtarw1;



        SETLL (001:001:INDCL_MTAR)   satmcli00;
        READE (001:001:INDCL_MTAR)   satmcli00;
    EXSR tCenmasc;
//ESCRIBE MODAL

APEL2_MCLI = %XLATE('¥':'Ñ':APEL2_MCLI);
APEL1_MCLI = %XLATE('¥':'Ñ':APEL1_MCLI);
RESPONSE='<div id="myModal" class="modal" tabindex="-1" role="dialog" aria-hidden="true"'+
    ' aria-labelledby="myLargeModalLabel" >'+crlf+
'<div class="modal-dialog modal-dialog-centered modal-lg" role="document">'+crlf+
'<div class="modal-content">                                                                 '+crlf+
'<div class="modal-header">'+crlf+
'<h4 class="modal-title">Detalle de cuenta</h4>'+crlf+
'<button type="button" class="btn-close" data-bs-dismiss="modal" aria-hidden="true"></button>'+crlf+
'</div>'+crlf+
'<div class="modal-body">'+crlf+
'  <div id="detail" style="margin-bottom: 54px;">                                                     '+crlf+
'  <div id="detailContainer">                                                                         '+crlf+
' <div>                                                                                               '+crlf+
'<div class="row">                                                                      '+crlf+
'                  <div class="col-xs-5 text-upper col-sm-5 col-md-6 col-lg-5 dp-th">                 '+crlf+
'                      <h5>Nombre de Cliente:</h5>                                                    '+crlf+
'                  </div>                                                                             '+crlf+
'                  <div class="col-xs-7 col-sm-6 col-md-6 col-lg-7">                                  '+crlf+
'   <p class="fontData" >'+CRLF+
NOMB1_MCLI+'&nbsp;'+NOMB2_MCLI+'&nbsp;'+APEL1_MCLI+'&nbsp;'+APEL2_MCLI+'</p>'                     +crlf+
'                  </div>                                                                             '+crlf+
'                  </div>                                                                             '+crlf+
'              <div class="row">                                                                      '+crlf+
'                  <div class="col-xs-5 text-upper col-sm-5 col-md-6 col-lg-5 dp-th">                 '+crlf+
'                      <h5>Número de cuenta:</h5>                                                      '+crlf+
'                  </div>                                                                             '+crlf+
'                  <div class="col-xs-7 col-sm-6 col-md-6 col-lg-7">                                  '+crlf+
'   <p id="tj" class="fontData mainVal"><small><em>'+numta1+'&nbsp;&nbsp;'                                  +
'&nbsp;'+NUMTA2+'**&nbsp;&nbsp;&nbsp;****&nbsp;&nbsp;&nbsp;'+numta4+'</em></small></p><var id="tcv" hidden>'+
%trim(numta1+numta2+numta4+%char(codcl_mtar))+'</var>'               +crlf+
'                  </div>                                                                             '+crlf+
'              </div>                                                                                 '+crlf;
       Codigo = %editc(STSRD_MTAR:'X');
        prefix = 'SAT_STSTC';
       exsr SR_SATDESC00;

RESPONSE = %trimr(RESPONSE)+
'              <div class="row">                                                                      '+crlf+
'                  <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                            '+crlf+
'                      <h5>Estado de Tarjeta:</h5>                                                     '+crlf+
'                  </div>                                                                             '+crlf+
'                  <div class="col-xs-7 col-sm-6 col-md-6 col-lg-7">                                  '+crlf+
'                      <p class="fontData2" style="text-transform: Capitalize;">'+%trim(descrip)+'</p>'+crlf+
'                  </div>                                                                             '+crlf+
'          </div>                                                                                     '+crlf;
                    Codigo = %editc(codts_mtar:'X');
                    prefix = 'SAT_TSERV';
                    exsr SR_SATDESC00;
RESPONSE = %trimr(RESPONSE)+
'              <div class="row">                                                                      '+crlf+
'                  <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                            '+crlf+
'                      <h5>Tipo de Servicio:</h5>                                                      '+crlf+
'                  </div>                                                                             '+crlf+
'                  <div class="col-xs-7 col-sm-6 col-md-6 col-lg-7">                                  '+crlf+
'                      <p class="fontData2"  style="text-transform: capitalize;">'+%trim(descrip)+'</p>'+crlf+
'         </div>                                                                  '+crlf+
'              </div>                                                                                 '+crlf;
       Codigo = %editc(codpr_mtar:'X');
        prefix = 'SAT_PROD';
            exsr SR_SATDESC00;

RESPONSE = %trimr(RESPONSE)+
'              <div class="row">                                                                      '+crlf+
'                  <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                            '+crlf+
'                      <h5>Producto:</h5>                                                              '+crlf+
'                  </div>                                                                             '+crlf+
'                  <div class="col-xs-7 col-sm-6 col-md-6 col-lg-7">                                  '+crlf+
'                      <p class="fontData2" style="text-transform: Capitalize;">'+descrip+'</p>        '+crlf+
'                  </div>                                                                             '+crlf+
'              </div>                                                                                 '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5>Sucursal :</h5>                                                           '+crlf+
'                    </div>                                                                           ';
Codigo = %editc(sucur_mtar:'X');
        prefix = 'SAT_SUC';
            exsr SR_SATDESC00;
RESPONSE = %trimr(RESPONSE)+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
'                <p class="fontData mainVal"  style="text-transform: Capitalize;">'+descrip+'</p>     '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf;
   Setll (001:001:tcact_mtar)   saumcta00;
   READE (001:001:tcact_mtar)   saumcta00;
   Codigo = SPCON_MCTA;
   prefix = 'SAU_SPCOND';
            exsr SR_SATDESC00;
RESPONSE = %trimr(RESPONSE)+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5>Condicion Especial :</h5>                                                '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
'<p class="fontData2"  style="text-transform: Capitalize;">'+DESCRIP+'</p>  '+crlf+
'                    </div>                                                                           '+crlf+
'                  </div>                                                                             '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5>Ciclo :</h5>                                                  '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
'                <p class="fontData2">'+%editc(CODCI_MTAR:'X')+'</p>'+crlf+
'                  </div>                                                                             '+crlf+
'                </div>                                                                               '+crlf;
Codigo = CLATC_MTAR;
   prefix = 'SAT_CLATC';
            exsr SR_SATDESC00;
RESPONSE = %trimr(RESPONSE)+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5>Clase de Tarjeta :</h5>                                                  '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
'                <p class="fontData2"  style="text-transform: Capitalize;">'+DESCRIP+'</p>  '+crlf+
'                  </div>                                                                             '+crlf+
'                </div>                                                                               '+crlf;
Codigo = TIPTC_MTAR;
   prefix = 'SAT_TIPTC';
            exsr SR_SATDESC00;
RESPONSE = %trimr(RESPONSE)+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5>Tipo de Tarjeta :</h5>                                                    '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
'                <p class="fontData2" style="text-transform: Capitalize;">'+DESCRIP+'</p>  '+crlf+
'                  </div>                                                                             '+crlf+
'                </div>                                                                               '+crlf;
Codigo = INTES_MTAR;
   prefix = 'SAU_SPCOND';
            exsr SR_SATDESC00;
RESPONSE = %trimr(RESPONSE)+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5>Intrucion Especial :</h5>                                                '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
'                <p class="fontData2" style="text-transform: Capitalize;">'+DESCRIP+'</p>  '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'                </div>                                                                               '+crlf+
'                </div>                                                                               '+crlf+
'                </div>                                                                               '+crlf+
'            </div>                                                                                   '+crlf+
'<div class="modal-footer">'+crlf;

SETLL (001:001:TCACT_MTAR) SATMSAL00;
reade (001:001: TCACT_MTAR) SATMSAL00;
if not %equal (satmsal00);
 buttons ='no tiene ningun saldo';
else;

DOW Not %EOF (SATMSAL00);
IF MONED_MSAL=840;
    MONEDW = '84';
    MONEDA ='USD';
        ELSE;
        IF MONED_MSAL = 214;
    MONEDW = '21';
    MONEDA ='DOP';
        ELSE;
        IF MONED_MSAL = 978;
    MONEDW = '97';
    MONEDA = 'EUR';
    endif;
endif;
endif;
BUTTONS = %TRIM(BUTTONS) + '<button data-dismiss="modal" class="btn btn-outline-warning" type="button" id="'+
MONEDA+'" value="'+MONEDW+'" onclick="tcSaldo(value)">Ver saldo '+MONEDA+'</button>'+crlf;

reade (001:001:TCACT_MTAR) satmsal00;
ENDDO;
DATA = '        </div>                                                                                '+crlf+
'    </div>                                                                                           '+crlf+
'</div>'+crlf+
'    </div>                                                                                           '+crlf+
'</div>                                                                                               '+crlf;
RESPONSE = %TRIMr(RESPONSE) + %TRIMr(BUTTONS) + %TRIMr(DATA);
 endif;
endsr;

BEGSR SR_SATDESC00;
  callp SATIDES01(banco: cia: prefix: codigo: descrip);
      descrip = %xlate(uppercase:lowercase:descrip);
      *inlr = '1';
ENDSR;


BEGSR TCSAL;
bin = %subst(f02:1:6);
numta4= %subst(f02:7:10);
codcl= %subst(f02:11:24);

chain (001:001:%DEC(codcl:14:0):bin:numta4) satmtarw1;
numta = %float(tcact_mtar);
IF F01=84;
    MONED = 840;
        ELSEIF F01 =21;
    MONED = 214;
        ELSEIF F01 =97;
    MONED = 978;
    endif;
IF MONED = 214;
       MONEDA = 'DOP';
       ELSE;
       MONEDA='USD';
       ENDIF;
USRPAR_VAR = 'VMHOWLEY';

     chain (001:001:INDCL_MTAR)   satmcli00;
     callp satc0004(CODBP: CODCP: DSC_COPRS: DSC_COPRS: USRPAR_VAR: INDCL_MTAR:
                    numta: MONED: PAR: SATC0004FL);
       EXSR tcenmasc;

response='<div id="saldopr" class="card">'+crlf+
'<input  id="saldoval" value="'+%char(moned)+'" type="hidden">'+crlf+
'<div class="card-body">                                                                         '+crlf+
'<div class="card-widgets">'+crlf+
  '<a href="javascript:;" data-bs-toggle="reload"><i class="mdi mdi-refresh"></i></a>'+crlf+
  '<a id="minimicoll2"data-bs-toggle="collapse" href="#cardCollpase2" role="button" aria-expanded="fal'+
  'se" aria-controls="cardCollpase2"><i class="mdi mdi-minus"></i></a>'+crlf+
                '</div>'+crlf+
'<h5 class="card-title text-center ">Saldos</h5>'+crlf+
'<div class="pt-3 collapse show" id="cardCollpase2">'+crlf+
'<div class="row justify-content-md-center">'+crlf+
'<div class="col-lg-10">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'              <div class="row">                                                                      '+crlf+
'                  <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                            '+crlf+
'                      <h5>ID de Cliente:</h5>                                                        '+crlf+
'                  </div>                                                                             '+crlf+
'                  <div class="col-xs-7 col-sm-6 col-md-6 col-lg-7">                                  '+crlf+
'   <p class="h5">'+%trim(indcl_mtar)+'</p>'+crlf+
'                  </div>                                                                             '+crlf+
'              </div>                                                                                 '+crlf+
'<div class="row">                                                                      '+crlf+
'                  <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                            '+crlf+
'                      <h5>Moneda:</h5>                                                        '+crlf+
'                  </div>                                                                             '+crlf+
'                  <div class="col-xs-7 col-sm-6 col-md-6 col-lg-7">                                  '+crlf+
'   <p class="h5">'+%trim(moneda)+'</p>'+crlf+
'                  </div>                                                                             '+crlf+
'              </div>                                                                                 '+crlf+
'              <div class="row">                                                                      '+crlf+
'                  <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                            '+crlf+
'                      <h5>Número de Tarjeta:</h5>                                                    '+crlf+
'                  </div>                                                                             '+crlf+
'                  <div class="col-xs-7 col-sm-6 col-md-6 col-lg-7">                                  '+crlf+
'   <p id="tj" class="h5">'+numta1+'&nbsp;'+numta2+'**&nbsp;*'+
'***&nbsp;'+numta4+'</p>'+
crlf+
'                  </div>                                                                             '+crlf+
'              </div>                                                                                 '+crlf+
'              <div class="row">                                                                      '+crlf+
'                  <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                            '+crlf+
'                      <h5>Limite de Credito:</h5>                                                    '+crlf+
'                  </div>                                                                             '+crlf+
'                  <div class="col-xs-7 col-sm-6 col-md-6 col-lg-7">                                  '+crlf+
'                <p class="h5">'+%editc(limrd_msw:'1':*cursym)+
'</p>'+crlf+
'         </div>                                                          '+crlf+
'         </div>                                                          '+crlf+
'              </div>                                                                                 '+crlf+
'              </div>                                                                                 '+crlf+
'              </div>                                                                                 '+crlf+
'              </div>                                                                                 '+crlf;

Codigo = %editc(codpr_mtar:'X');
prefix = 'SAT_PROD';
exsr SR_SATDESC00;
       Setll (001:001:tcact_mtar)   satmtar00;
       READE (001:001:tcact_mtar)   satmtar00;
response = %trimr(response)+ '<div class="row">'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'              <div class="row">                                          '+crlf+
'                  <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                            '+crlf+
'                      <strong><h5><u>saldo al Corte:</u></h5></strong>                               '+crlf+
'                  </div>                                                                             '+crlf+
'                  <div class="col-xs-7 col-sm-6 col-md-6 col-lg-7">                                  '+crlf+
'                <p class="h5">'+%editc(MONBALACOW:'1':*cursym)+
'</p>'+crlf+
'                </div>                                                                               '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                          '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SACCA_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>interes:</li></h5>                                                '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SACIN_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                               '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SACCO_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                                 '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SACCG_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'<a id="minimicoll4"  onclick="tcSaldotr();" href="#RESPONSE5"  role="button"'+
' aria-expanded="false">'+
'                        <h5><u>Saldo Actual:</u></h5></a>                                            '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="h5">'+%editc(BALANCFECW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                          '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SACTC_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>interes:</li></h5>                                                '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SACTI_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                               '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SACTO_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                                 '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SACTG_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><u>Corte Anterior:</u></h5>                                             '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="h5">'+%editc(CORTE_ANTW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                            '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                          '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SCAMA_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>interes:</li></h5>                                                '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SACTI_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                               '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SCOMA_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                                 '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SCOMG_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><u>Pago del Mes:</u></h5>                                             '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(VALCUOTAMW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                          '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(PAGME_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>interes:</li></h5>                                                '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(PAGIE_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                               '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(PAGCE_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                                 '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(PAGMG_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><u>Pago Minimo:</u></h5>                                             '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(PAGO_MINIW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                          '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(PAGMI_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>interes:</li></h5>                                                '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(PAGII_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                               '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(PAGCI_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                                 '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(PAMCG_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5>Mora Pendiente:</h5>                                                 '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%EDITC(MUSGI_MSAW:'1':*CURSYM)+'</p> '+crlf+
'                </div>                                                                               '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'<a id="minimicoll2"  onclick="tcSaldovenc();" href="#RESPONSE4"  role="button" aria-expanded="false">'+
'<h5><u>Importe Vencido:</u></h5></a>           '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MONTOVENCW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                          '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SVECA_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>interes:</li></h5>                                                '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SVEIN_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                               '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SVECO_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                                 '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(SVECG_MSAW:'1':*cursym)+'</p> '+crlf+
'                </div>                                                                               '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5>CxS Y F/Mes:</h5>                                             '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(CXSEW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5>Pagos Vencidos:</h5>                                          '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%char(CANPV_MSAW)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5>Fecha Ultimo Pago:</h5>                                         '+crlf+
'                    </div>                                                                           '+crlf+
'                  <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">    '+crlf;
                   MONITOR;
 response = %trimr(response)+
  ' <p class="fontData2">'+%char(%date(FUPAG_MSAW:*eur))+'</p> '+crlf+
  '                </div>                                                                           '+crlf+
  '               </div>                                                                               '+crlf;
 ON-ERROR;
 response = %trimr(response)+
  ' <p class="fontData2">'+%char(FUPAG_MSAW)+'</p> '+crlf+
  '                </div>                                                                           '+crlf+
  '               </div>                                                                            '+crlf;
  ENDMON;
 response = %trimr(response)+
'<div class="row">                                                        '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5>Ultimo Pago:</h5>                                               '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MUPAG_MSAW:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'    </div>                                                                                           '+crlf+
'</div>                                                                                               '+crlf+
'</div>                                                                                               '+crlf+
'</div>'+crlf+
'    </div>                                                                                           '+crlf+
'</div>                                                                                               '+crlf;
ENDSR;

begsr saldovenc;

bin = %subst(f02:1:6);
numta4= %subst(f02:7:10);
codcl= %subst(f02:11:24);

chain (001:001:%DEC(codcl:14:0):bin:numta4) satmtarw1;
numta = %float(tcact_mtar);
IF F01=84;
    MONED = 840;
        ELSEIF F01 =21;
    MONED = 214;
        ELSEIF F01 =97;
    MONED = 978;
    endif;
IF MONED = 214;
       MONEDA = 'DOP';
       ELSE;
       MONEDA='USD';
       ENDIF;
//     numta = %DEC(%trim(F02):16:0);
        SETLL (CODBP:CODCP:numta:MONED)   satmsal00;
             READE (CODBP:CODCP:numta:MONED)   satmsal00;
response = '<div id="saldovenc" class="card">'+crlf+
'<div class="card-body">                                                                         '+crlf+
'<div class="card-widgets">'+crlf+
  '<a href="javascript:;" data-bs-toggle="reload"><i class="mdi mdi-refresh"></i></a>'+crlf+
  '<a id="minimicoll3" data-bs-toggle="collapse" href="#cardCollpase3" role="button" aria-expanded="fal'+
  'se" aria-controls="cardCollpase3"><i class="mdi mdi-minus"></i></a>'+crlf+
                '</div>'+crlf+
'<h5 class="card-title text-center">Saldos Vencidos</h5>'+crlf+
'<div class="pt-3 collapse show" id="cardCollpase3">'+crlf+
'<div class="row">'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'              <div class="row">                                          '+crlf+
'                  <div class="card-title text-center ">                '+crlf+
'                      <h4>Mora a 30 Dias</h4>                               '+crlf+
'                  </div>                                                                             '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MC030_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Interes:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MI030_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                     '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MO030_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                       '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MG030_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="row">                                          '+crlf+
'                  <div class="card-title text-center ">                '+crlf+
'                      <h4>Mora a 60 Dias</h4>                               '+crlf+
'                  </div>                                                                             '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MC060_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Interes:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MI060_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                     '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MO060_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                       '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MG060_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="row">                                          '+crlf+
'                  <div class="card-title text-center ">                '+crlf+
'                      <h4>Mora a 90 Dias</h4>                               '+crlf+
'                  </div>                                                                             '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MC090_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Interes:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MI090_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                     '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MO090_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                       '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MG090_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="row">                                          '+crlf+
'                  <div id="mora120"class="card-title text-center ">                '+crlf+
'                      <h4>Mora a 120 Dias</h4>                               '+crlf+
'                  </div>                                                                             '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MC120_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Interes:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MI120_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                     '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MO120_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                       '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MG120_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="row">                                          '+crlf+
'                  <div class="card-title text-center ">                '+crlf+
'                      <h4>Mora a 150 Dias</h4>                               '+crlf+
'                  </div>                                                                             '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MC150_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Interes:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MI150_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                     '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MO150_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                       '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MG150_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="row">                                          '+crlf+
'                  <div class="card-title text-center ">                '+crlf+
'                      <h4>Mora a 180 Dias</h4>                               '+crlf+
'                  </div>                                                                             '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MC180_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Interes:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MI180_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                     '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MO180_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                       '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MG180_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>'+crlf+
'<div class="col-lg-4">'+crlf+
'<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="row">                                          '+crlf+
'                  <div class="card-title text-center ">                '+crlf+
'                      <h4>Mora a mas de 180 Dias</h4>                               '+crlf+
'                  </div>                                                                             '+crlf+
'                </div>                                                                               '+crlf+
'                <div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Capital:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MCMAS_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Interes:</li></h5>                                      '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MIMAS_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Comision:</li></h5>                                     '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MOMAS_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'<div class="row">                                                                    '+crlf+
'                    <div class="col-xs-5 col-sm-5 col-md-6 col-lg-5 dp-th">                          '+crlf+
'                        <h5><li>Cargos:</li></h5>                                       '+crlf+
'                    </div>                                                                           '+crlf+
'                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-7">                                '+crlf+
' <p class="fontData2">'+%editc(MGMAS_MSAL:'1':*cursym)+'</p> '+crlf+
'                    </div>                                                                           '+crlf+
'                </div>                                                                               '+crlf+
'</div>'+crlf+
'</div>'+crlf+
'</div>';
ENDSR;

begsr saldovenctr;
bin = %subst(f02:1:6);
numta4= %subst(f02:7:10);
codcl= %subst(f02:11:24);

chain (001:001:%DEC(codcl:14:0):bin:numta4) satmtarw1;
numta = %float(tcact_mtar);
clear data;
IF F01=84;
    MONED = 840;
        ELSEIF F01 =21;
    MONED = 214;
        ELSEIF F01 =97;
    MONED = 978;
    endif;
IF MONED = 214;
       MONEDA = 'DOP';
       ELSE;
       MONEDA='USD';
       ENDIF;


   SETLL (CODBP:CODCP:numta:MONED)   satflot04;
   READE (CODBP:CODCP:numta:MONED)   satflot04;

IF  Not %EQUAL;
RESPONSE = '<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="card-widgets">'+crlf+
  '<a href="javascript:;" data-bs-toggle="reload"><i class="mdi mdi-refresh"></i></a>'+crlf+
  '<a id="minimicoll4" data-bs-toggle="collapse" href="#cardCollpase4" role="button" aria-expanded="fal'+
  'se" aria-controls="cardCollpase4"><i class="mdi mdi-minus"></i></a>'+crlf+
                '</div>'+crlf+
'<h5 class="card-title text-center">Transacciones</h5>'+crlf+
'<div class="pt-3 collapse show" id="cardCollpase4">'+crlf+
'<div class="alert alert-danger alert-dismissible bg-danger text-white border-0 fade show" role="alert">'+
crlf+'<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>'+crlf+
' <strong>Error - </strong> No hay transacciones existentes'+crlf+
'</div>                        '+crlf+
'</div>                                                            '+crlf+
'</div>                                                            '+crlf;
ELSE;
Dow not %Eof (satflot04);

IF        CODTR_FLOT <> 45 AND CODTR_FLOT <> 46 ;

IF        (CODTR_FLOT=31 OR CODTR_FLOT=35 OR  CODTR_FLOT=36 OR CODTR_FLOT=12 or CODTR_FLOT=06 );
CREDITO = VALTR_FLOT;
CLEAR DEBITO;
ELSE;
DEBITO = VALTR_FLOT;
CLEAR CREDITO;
ENDIF;
ElSE;
IF   (CODTR_FLOT=31 OR CODTR_FLOT=35 OR CODTR_FLOT=36 OR CODTR_FLOT=12 OR CODTR_FLOT=06 OR CODTR_FLOT=46);
CREDITO =  VALTR_FLOT;
CLEAR DEBITO;
ELSE;
DEBITO = VALTR_FLOT;
CLEAR CREDITO;
ENDIF;
ENDIF;
cr = %editc(credito:'1':*CURSYM);
db = %editc(debito:'1':*CURSYM);
data=%trim(data)+
'<tr style="text-align:center">                              '+crlf+
'  <td>'+DESTR_FLOT+'</td>                     '+crlf+
'  <td >'+%trim(%char(CODTR_FLOT))+'</td>              '+crlf+
'  <td>'+%char(%date(FECTR_FLOT:*EUR))+'</td>  '+crlf+
'  <td>'+%char(%date(FECPR_FLOT:*EUR))+'</td>  '+crlf+
'  <td>'+DB+'</td>                             '+crlf+
'  <td>'+CR+'</td>                            '+crlf+
'</tr>                                         '+crlf;
       READE (CODBP:CODCP:numta:MONED)   satflot04;
enddo;

response='<div class="card">'+crlf+
'<div class="card-body">'+crlf+
'<div class="card-widgets">'+crlf+
  '<a href="javascript:;" data-bs-toggle="reload"><i class="mdi mdi-refresh"></i></a>'+crlf+
  '<a id="minimicoll4" data-bs-toggle="collapse" href="#cardCollpase4" role="button" aria-expanded="fal'+
  'se" aria-controls="cardCollpase4"><i class="mdi mdi-minus"></i></a>'+crlf+
                '</div>'+crlf+
'<h5 class="card-title text-center">Transacciones</h5>'+crlf+
'<div class="pt-3 collapse show" id="cardCollpase4">'+crlf+
'<div class="table-responsive">'+CRLF+
'<table id="basic-datatable1" class="table  dt-responsive nowrap w-100">'+crlf+
'    <thead>                                                       '+crlf+
'        <tr style="text-align:center">                                                      '+crlf+
'            <th>Descripcion</th>                                  '+crlf+
'            <th>Codigo Transaccion</th>                           '+crlf+
'            <th>Fecha transaccion</th>                            '+crlf+
'            <th>Fecha Proceso</th>                                '+crlf+
'            <th>Debito</th>                                       '+crlf+
'            <th>Credito</th>                                      '+crlf+
'        </tr>                                                     '+crlf+
'    </thead>                                                      '+crlf+
'    <tbody>                                                       '+crlf+
data+
'    </tbody>                                                      '+crlf+
'</table>                                                          '+crlf+
'</div>                                                            '+crlf+
'</div>                                                            '+crlf+
'</div>                                                            '+crlf+
'</div>'+crlf+
'</div>'+crlf;
ENDIF;
endsr;

BEGSR tCenmasc;
numta1 = %subst(%char(TCACT_MTAR):1:4);
numta2 = %subst(%char(TCACT_MTAR):5:7);
numta4 = %subst(%char(TCACT_MTAR):13:4);
ENDSR;
