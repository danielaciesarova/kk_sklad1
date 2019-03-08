unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Grids, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure CheckBox6Change(Sender: TObject);
    procedure CheckBox7Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3EditingDone(Sender: TObject);
    procedure Edit4EditingDone(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure Cistenie ();
    procedure RadioButton2Change(Sender: TObject);
    procedure Zobraz(kategoria:string);
    procedure Zorad ();
    procedure ZobrazenieCeny (premienanaCena:integer);
    procedure VyberKategorii();
    procedure ZiskajDatum();
    procedure CitanieStatistik();
    procedure ID();
    procedure Locky (nazovSuboru:string);
    procedure Verzie (nazovSuboru:string);
    procedure DisplayMessageBox(nArtiklov:integer; typObjednavky:string);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure StringGrid2DblClick(Sender: TObject);
    procedure StringGrid2EditingDone(Sender: TObject);
    procedure StringGrid2PrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
    procedure StringGrid2SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
type
  recData =record
    kod:integer;
    nazov:string;
    ks,cenaZaKs:integer;
    end;
type
  recObjednavka =record
    kod,ks,cenaZaKs,cenaSpolu:integer;
    nazov:string;
    end;
  type
  recCeny =record
    kod:integer;
    cenaZaKs:integer;
    end;
  type
  recTovar =record
    kod:integer;
    nazov:string;
    end;
  type
  recStatistiky =record
    kod,ks,cenaSpolu:integer;
    typTransakcie,datum,IDtransakcie:string;
    end;
const n=50;
const m=150;
//const Path='Z:\INFProjekt2019\TimB\';
const Path='';
var
  sSklad1,sSklad2,sTovar,sCeny,sStatistiky,sKategorie,
  sSkladLock,sTovarLock,sCenyLock,sStatistikyLock,
  sSKladVerzia,sTovarVerzia,sCenyVerzia,sStatistikyVerzia:textfile;
  data:array [1..n] of recData;
  zobrazene:array [1..n] of recData;
  nedostatok:array [1..n] of recObjednavka;
  objednavka:array [1..n] of recObjednavka;
  ceny:array [1..n] of recCeny;
  tovar:array [1..n] of recTovar;
  statistiky:array [1..m] of recStatistiky;
  kategorie:array [1..4] of string;
  suhlas:boolean;
  nData,nObjednavka,nZobrazene,nNedostatok,NStatistiky,nCeny,nTovar,
  riadokZobrazene,riadokObjednavka,
  stlpecZobrazene,stlpecObjednavka,
  verziaTovar,verziaSklad,verziaCeny,verziaStatistiky,
  predverziaTovar,predverziaSklad,predverziaCeny,predverziaStatistiky:integer;
  datum,c1,IDcislo:string;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i,j,k,poz,pomNData,bezNazvu:integer;
    pom1,pom2,sub:string;
begin
  { ToDo:
    -design}

  randomize;

  //1.Cistenie  -Memo,Data,Nedostatok,Zobrazene,Objednavka,Verzie
  Cistenie;
  Memo1.Clear;
  Memo1.Append('Vitajte v systeme SKLAD obchodneho retazca KinderKaufland.');
  nZobrazene:=0;
  nObjednavka:=0;

  For i:=1 to n do
  begin
    zobrazene[i].kod:=0;
    zobrazene[i].nazov:='';
    zobrazene[i].ks:=0;
    zobrazene[i].cenaZaKs:=0;

    objednavka[i].kod:=0;
    objednavka[i].nazov:='';
    objednavka[i].ks:=0;
    objednavka[i].cenaZaKs:=0;
    objednavka[i].cenaspolu:=0;
  end;

  predverziaTovar:=1;
  predverziaSklad:=1;
  predverziaCeny:=1;
  predverziaStatistiky:=1;

   //2.Nacitanie dat: subor SKLAD
   sub:='sklad';
   Verzie(sub);
   If predverziaSklad<=verziaSklad then
   begin
     Locky(sub);
     AssignFile (sSklad2,Path+'sklad.txt');
     Reset (sSklad2);
     Readln(sSklad2,pom1);             //citanie riadku pocet poloziek
     pomNData:=strtoint(pom1);
     i:=0;
     While not eof(sSklad2) do        //citanie poloziek zo suboru do rekordu
     begin
       inc(i);
       Readln(sSklad2,pom1);
       trim(pom1);
       poz:=pos(';',pom1);
       pom2:=copy(pom1,1,poz-1);
       data[i].kod:=strtoint(pom2);
       delete(pom1,1,poz);
       data[i].ks:=strtoint(pom1);
     end;
     CloseFile(sSklad2);
     DeleteFile(Path+'SKLAD_LOCK.txt');
     predverziaSklad:=verziaSklad;

   //2.1.Kontrola citania dat
   If pomNData=i then nData:=pomNData else Memo1.Append('problem s nacitanim dat SKLAD');
  end;

   //3.Nacitanie dat: subor TOVAR
   //3.1.Nacitanie TOVAR
   sub:='tovar';
   Verzie(sub);
   If predverziaTovar<=verziaTovar then
   begin
     Locky(sub);
     AssignFile (sTovar,Path+'tovar.txt');
     Reset (sTovar);
     Readln(sTovar,pom1);             //citanie riadku pocet poloziek
     pomNData:=strtoint(pom1);
     i:=0;
     While not eof(sTovar) do        //citanie poloziek zo suboru do rekordu
     begin
       inc(i);
       Readln(sTovar,pom1);
       trim(pom1);
       poz:=pos(';',pom1);
       pom2:=copy(pom1,1,poz-1);
       tovar[i].kod:=strtoint(pom2);
       delete(pom1,1,poz);
       tovar[i].nazov:=pom1;
     end;
     CloseFile(sTovar);
     DeleteFile(Path+'TOVAR_LOCK.txt');
     predverziaTovar:=verziaTovar;

   //3.2.Kontrola citania dat
   If (pomNData=i) then nTovar:=i else Memo1.Append('problem s nacitanim dat TOVAR');
  end;

   //3.3.Priradenie nazvov z TOVAR do rekordu DATA
   bezNazvu:=0;
   For i:=1 to nData do
   begin
    j:=0;
    Repeat
     inc(j);
    until (data[i].kod = tovar[j].kod) or (j>=nTovar);
   If data[i].kod = tovar[j].kod then
   begin
     data[i].nazov:=tovar[j].nazov;
   end
   else
   begin
     inc(bezNazvu);
     data[i].nazov:=('bez nazvu'+inttostr(bezNazvu));
   end;
  end;

  //4.Nacitanie dat: subor CENNIK
  //4.1.Nacitanie CENNIK
  sub:='cennik';
   Verzie(sub);
   If predverziaCeny<=verziaCeny then
   begin
    Locky(sub);
    AssignFile (sCeny,Path+'cennik.txt');
    Reset (sCeny);
    Readln(sCeny,pom1);             //citanie riadku pocet poloziek
    pomNData:=strtoint(pom1);
    i:=0;
    While not eof(sCeny) do        //citanie poloziek zo suboru do rekordu
    begin
      Readln(sCeny,pom1);
      trim(pom1);
      If length(pom1)>3 then
        begin
          inc(i);
          poz:=pos(';',pom1);
          pom2:=copy(pom1,1,poz-1);
          ceny[i].kod:=strtoint(pom2);
          delete(pom1,1,poz);
          poz:=pos(';',pom1);
          delete(pom1,1,poz);
          ceny[i].cenaZaKs:=strtoint(pom1);
        end;
    end;
    CloseFile(sCeny);
    DeleteFile(Path+'CENNIK_LOCK.txt');
    predverziaCeny:=verziaCeny;

  //4.2.Kontrola citania dat
  If (pomNData=i) then nCeny:=i else Memo1.Append('niektore tovary nemaju zadanu CENU');
  end;
  nCeny:=i;

  //4.3.Priradenie cien z CENY do rekordu DATA
  i:=0;
  Repeat
   inc(i);
   j:=0;
     Repeat
      inc(j);
     until (data[i].kod = ceny[j].kod) or (j>=nCeny);
    If data[i].kod = ceny[j].kod then
    begin
      data[i].cenaZaKs:=ceny[j].cenaZaKs;
    end
    else
    begin
      data[nData+1]:=data[n];
      For k:= i to nData do
      begin
        data[k]:=data[k+1];
      end;
      dec(nData);
      dec(i);
    end;
  until i>=nData ;

  //5.Vykreslenie form StringGrid1 AKTUALNY STAV
  StringGrid1.Cells[1,0]:='Kod';
  StringGrid1.Cells[2,0]:='Nazov';
  StringGrid1.Cells[3,0]:='Mnozstvo';

  //6.Vykreslenie form StringGrid2 OBJEDNAVKA
  StringGrid2.RowCount:=1;
  StringGrid2.Cells[1,0]:='Nazov';
  StringGrid2.Cells[2,0]:='Mnozstvo';
  StringGrid2.Cells[3,0]:='Cena za ks';
  StringGrid2.Cells[4,0]:='Cena spolu';

  //7.Kategorie
  //7.1.Nacitanie: subor KATEGORIE
  AssignFile(sKategorie,'kategorie.txt');
  Reset(sKategorie);
  i:=0;
  While not eof(sKategorie) do
    begin
      inc(i);
      Readln(sKategorie,kategorie[i]);
    end;
  CloseFile (sKategorie);

  If i <> 4 then Memo1.Append('problem s nacitanim suboru KATEGORIE') else
  begin

  //7.2.Priradenie kategorii na CheckBoxy
  CheckBox3.Caption:=kategorie[1];
  CheckBox4.Caption:=kategorie[2];
  CheckBox5.Caption:=kategorie[3];
  CheckBox7.Caption:=kategorie[4];
  end;

  //8.Vykreslenie obsahu StringGrid1 AKTUALNY STAV
  VyberKategorii;

  ID;
end;

procedure TForm1.Cistenie();
var i:integer;
begin
  //C*I*S*T*E*N*I*E Data,Nedostatok
  nData:=0;
  nNedostatok:=0;

  For i:=1 to n do
  begin
    data[i].kod:=0;
    data[i].nazov:='';
    data[i].ks:=0;
    data[i].cenaZaKs:=0;

    nedostatok[i].kod:=0;
    nedostatok[i].nazov:='';
    nedostatok[i].ks:=0;
    nedostatok[i].cenaZaKs:=0;
    nedostatok[i].cenaspolu:=0;
  end;
end;

procedure TForm1.RadioButton2Change(Sender: TObject);
begin
  If RadioButton2.Checked = true then
  begin
   CheckBox1.Enabled:=false;
   Label2.Enabled:=false;
   Label6.Enabled:=false;
   Edit1.Enabled:=false;
   Edit2.Enabled:=false;
  end;
end;

procedure TForm1.Zobraz(kategoria:string);
var i,j,zhoda:integer;
    pom:string;
begin
   //Checknutu kategoriu pridaj do recordu ZOBRAZENE
    i:=0;
    Repeat
      inc(i);
      pom:=inttostr(data[i].kod);
      If pom[1] = kategoria then
          begin
            If nZobrazene>=0 then
              begin
                  zhoda:=0;
                  j:=0;
                  Repeat
                   inc(j);
                   If data[i].kod = zobrazene[j].kod then zhoda:=1;
                  until (j>=nZobrazene) or (zhoda>=1);

                  If zhoda = 0 then
                      begin
                        zobrazene[nZobrazene+1].kod:=data[i].kod;
                        zobrazene[nZobrazene+1].nazov:=data[i].nazov;
                        zobrazene[nZobrazene+1].ks:=data[i].ks;
                        zobrazene[nZobrazene+1].cenaZaKs:=data[i].cenaZaKs;
                        inc(nZobrazene);
                      end;
               end
              else
               begin
                zobrazene[1].kod:=data[i].kod;
                zobrazene[1].nazov:=data[i].nazov;
                zobrazene[1].ks:=data[i].ks;
                zobrazene[1].cenaZaKs:=data[i].cenaZaKs;
                inc(nZobrazene);
               end;
          end;
    until i>=nData;
end;

procedure TForm1.Zorad();
var i,j,max:integer;
begin
  If ComboBox1.ItemIndex <> (-1) then
  begin
  case ComboBox1.ItemIndex of
    0: begin
        For j:=1 to nZobrazene do
           begin
              max:=j;
             For i:=j to nZobrazene do
             begin
              If zobrazene[i].nazov<zobrazene[max].nazov then max:=i;
             end;
             zobrazene[nZobrazene+3]:=zobrazene[j];
             zobrazene[j]:=zobrazene[max];
             zobrazene[max]:=zobrazene[nZobrazene+3];
             zobrazene[nZobrazene+3]:=zobrazene[nZobrazene+2];
           end;
        end;
    1: begin
        For j:=1 to nZobrazene do
           begin
              max:=j;
             For i:=j to nZobrazene do
             begin
              If zobrazene[i].nazov>zobrazene[max].nazov then max:=i;
             end;
             zobrazene[nZobrazene+3]:=zobrazene[j];
             zobrazene[j]:=zobrazene[max];
             zobrazene[max]:=zobrazene[nZobrazene+3];
             zobrazene[nZobrazene+3]:=zobrazene[nZobrazene+2];
           end;
        end;
    2: begin
        For j:=1 to nZobrazene do
           begin
              max:=j;
             For i:=j to nZobrazene do
             begin
              If inttostr(zobrazene[i].kod)<inttostr(zobrazene[max].kod) then max:=i;
             end;
             zobrazene[nZobrazene+3]:=zobrazene[j];
             zobrazene[j]:=zobrazene[max];
             zobrazene[max]:=zobrazene[nZobrazene+3];
             zobrazene[nZobrazene+3]:=zobrazene[nZobrazene+2];
           end;
        end;
  end;
  end;

  //Vykreslenie StringGrid1 Aktualny stav
 If nZobrazene >=0 then
   begin
     StringGrid1.RowCount:=nZobrazene+1;
     For i:=1 to nZobrazene do
     begin
         StringGrid1.Cells[1,i]:=inttostr(zobrazene[i].kod);
         StringGrid1.Cells[2,i]:=zobrazene[i].nazov;
         StringGrid1.Cells[3,i]:=inttostr(zobrazene[i].ks);
         StringGrid1.Cells[0,i]:=inttostr(i);
     end;
   end;
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
var i,zhoda:integer;
begin
  //O*B*J*E*D*N*A*T

  //Kontrola, ci uz vybrany artikel je v Objednavke
  zhoda:=0;
  i:=0;
  Repeat
   inc(i);
   If zobrazene[riadokZobrazene].kod = objednavka[i].kod then zhoda:=1;
  until (i>=nObjednavka) or (zhoda>=1);

  case zhoda of
    0:
      begin
        objednavka[nObjednavka+1].kod:=zobrazene[riadokZobrazene].kod;
        objednavka[nObjednavka+1].nazov:=zobrazene[riadokZobrazene].nazov;
        objednavka[nObjednavka+1].ks:=1;
        objednavka[nObjednavka+1].cenaZaKs:=zobrazene[riadokZobrazene].cenaZaKs;
        Memo1.Append('pridanie do objednavky: '
        +objednavka[nobjednavka+1].nazov+' ('
        +inttostr(objednavka[nObjednavka+1].kod)+') x'
        +inttostr(objednavka[nObjednavka+1].ks));
        inc(nObjednavka);
      end;
    1:
      begin
        inc(objednavka[i].ks);
        Memo1.Append('zvysenie mnozstva: '+objednavka[i].nazov+' ('
        +inttostr(objednavka[i].kod)+') x'+inttostr(objednavka[i].ks));
      end;
  end;

  //Kalkulacia cienspolu za dany pocet ks
  If nObjednavka>0 then
  begin
    For i:=1 to nObjednavka do
    begin
      objednavka[i].cenaSpolu:=(objednavka[i].ks)*(objednavka[i].cenaZaKs);
    end;

  //Vykreslenie StringGrid2
    StringGrid2.RowCount:=nObjednavka+1;
    For i:=1 to nObjednavka do
    begin
        StringGrid2.Cells[1,i]:=objednavka[i].nazov;
        StringGrid2.Cells[2,i]:=inttostr(objednavka[i].ks);
        ZobrazenieCeny(objednavka[i].cenaZaKs);
        StringGrid2.Cells[3,i]:=c1;
        ZobrazenieCeny(objednavka[i].cenaSpolu);
        StringGrid2.Cells[4,i]:=c1;
        StringGrid2.Cells[0,i]:=inttostr(i);
    end;
    Button2.Enabled:=true;
   end;
end;

procedure TForm1.StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
begin
 if gdFixed in aState then exit;
 if (aRow = StringGrid1.Row) then
 StringGrid1.Canvas.Brush.color:=RGBtoColor(60,0,0);
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  riadokZobrazene:=aRow;
  stlpecZobrazene:=aCol;
  StringGrid1.Invalidate;
end;

procedure TForm1.StringGrid2DblClick(Sender: TObject);
var i:integer;

begin
  //O*D*S*T*R*A*N*E*N*I*E Z O*B*J*E*D*N*A*V*K*Y
  If nObjednavka>0 then
  begin
    Memo1.Append('odstranenie z objednavky: '
    +objednavka[riadokObjednavka].nazov+' ('
    +inttostr(objednavka[riadokObjednavka].kod)+') x '
    +inttostr(objednavka[riadokObjednavka].ks)
    +' -> '+'0');

    objednavka[nObjednavka+1].kod:=objednavka[n].kod;
    objednavka[nObjednavka+1].nazov:=objednavka[n].nazov;
    objednavka[nObjednavka+1].ks:=objednavka[n].ks;
    objednavka[nObjednavka+1].cenaZaKs:=objednavka[n].cenaZaKs;
    objednavka[nObjednavka+1].cenaspolu:=objednavka[n].cenaspolu;

    For i:=riadokObjednavka to nObjednavka do
    begin
      objednavka[i].kod:=objednavka[i+1].kod;
      objednavka[i].nazov:=objednavka[i+1].nazov;
      objednavka[i].ks:=objednavka[i+1].ks;
      objednavka[i].cenaZaKs:=objednavka[i+1].cenaZaKs;
      objednavka[i].cenaspolu:=objednavka[i+1].cenaspolu;
    end;
    dec(nObjednavka);

    If nObjednavka>=0 then
    begin
    StringGrid2.RowCount:=nObjednavka+1;
    For i:=1 to nObjednavka do
      begin
          StringGrid2.Cells[1,i]:=objednavka[i].nazov;
          StringGrid2.Cells[2,i]:=inttostr(objednavka[i].ks);
          ZobrazenieCeny(objednavka[i].cenaZaKs);
          StringGrid2.Cells[3,i]:=c1;
          ZobrazenieCeny(objednavka[i].cenaSpolu);
          StringGrid2.Cells[4,i]:=c1;
          StringGrid2.Cells[0,i]:=inttostr(i);
      end;
    end;
  end;
end;

procedure TForm1.StringGrid2EditingDone(Sender: TObject);
var i:integer;
    pom:string;
begin
 If nObjednavka>0 then
 begin
   If stlpecObjednavka=2 then
     begin
     If StringGrid2.Cells[stlpecObjednavka,riadokObjednavka]='' then StringGrid2.Cells[stlpecObjednavka,riadokObjednavka]:='0';
     pom:=inttostr(objednavka[riadokObjednavka].ks);
     objednavka[riadokObjednavka].ks:=strtoint(StringGrid2.Cells[stlpecObjednavka,riadokObjednavka]);
     objednavka[riadokObjednavka].cenaSpolu:=(objednavka[riadokObjednavka].ks)*
     (objednavka[riadokObjednavka].cenaZaKs);
     Memo1.Append('uprava mnozstva: '+objednavka[riadokObjednavka].nazov+' ('
    +inttostr(objednavka[riadokObjednavka].kod)+') x '
    +pom+' -> '+StringGrid2.Cells[stlpecObjednavka,riadokObjednavka]);
     end;

     //Kontrola pocet kusov v objednavke=0
     If objednavka[riadokObjednavka].ks<=0 then
      begin
        for i:=riadokObjednavka to nObjednavka do
        begin
          objednavka[i].kod:=objednavka[i+1].kod;
          objednavka[i].nazov:=objednavka[i+1].nazov;
          objednavka[i].ks:=objednavka[i+1].ks;
          objednavka[i].cenaZaKs:=objednavka[i+1].cenaZaKs;
          objednavka[i].cenaspolu:=objednavka[i+1].cenaspolu;
        end;
       dec(nObjednavka);
      end;

     //Vykreslenie StringGrid2 OBJEDNAVKA
     StringGrid2.RowCount:=nObjednavka+1;
      For i:=1 to nObjednavka do
      begin
          StringGrid2.Cells[1,i]:=objednavka[i].nazov;
          StringGrid2.Cells[2,i]:=inttostr(objednavka[i].ks);
          ZobrazenieCeny(objednavka[i].cenaZaKs);
          StringGrid2.Cells[3,i]:=c1;
          ZobrazenieCeny(objednavka[i].cenaSpolu);
          StringGrid2.Cells[4,i]:=c1;
          StringGrid2.Cells[0,i]:=inttostr(i);
      end;
   end;

end;

procedure TForm1.StringGrid2PrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
begin
 if gdFixed in aState then exit;
 if (aRow = StringGrid2.Row) then
 StringGrid2.Canvas.Brush.color:=RGBtoColor(155,5,30);
end;

procedure TForm1.StringGrid2SelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  riadokObjednavka:=aRow;
  stlpecObjednavka:=aCol;
  StringGrid2.Invalidate;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var i,j,k,poz,pomNData,zhoda,bezNazvu:integer;
    pom1,pom2,pomTypObj,sub:string;
begin
  //R*E*F*R*E*S*H

 Memo1.Clear;

 //1.AUTOMATICKA OBJEDNAVKA
 //1.1.Vyhladanie tovarov
 If RadioButton1.Checked = true then
  begin
  Memo1.Append('--------Automaticka objednavka--------');
  nNedostatok:=0;
  For i:=1 to nData do
    begin
    If data[i].ks < (strtoint(Edit1.text)) then
       begin
        inc(nNedostatok);
        nedostatok[nNedostatok].kod:=data[i].kod;
        nedostatok[nNedostatok].nazov:=data[i].nazov;
        nedostatok[nNedostatok].ks:=strtoint(Edit2.text);
        nedostatok[nNedostatok].cenaZaKs:=data[i].cenaZaKs;
        nedostatok[nNedostatok].cenaSpolu:=((nedostatok[nNedostatok].ks)*(nedostatok[nNedostatok].cenaZaKs));

        If CheckBox1.Checked = false then
        begin
          inc(data[i].ks,strtoint(Edit2.text));
          Memo1.Append('doobjednal som: '
          +nedostatok[nNedostatok].nazov+' ('
          +inttostr(nedostatok[nNedostatok].kod)+') x '+inttostr(data[i].ks)
          +' -> '+inttostr(data[i].ks+strtoint(Edit2.text)));
        end;
       end;
    end;

  //1.2.Nakup
  If (nNedostatok>0) and (strtoint(Edit2.text)>0)then
  begin
    If CheckBox1.Checked=true then
    begin
      RadioButton1.Checked:=false;
      pomTypObj:='Automatickej objednavky';
      DisplayMessageBox(nNedostatok,pomTypObj);

      If suhlas = true then
      begin
        For i:=1 to nNedostatok do
            begin
            j:=0;
             Repeat
             inc(j);
             until (nedostatok[i].kod = data[j].kod) or (j>=nData);
             If  nedostatok[i].kod = data[j].kod then
             begin
               inc(data[j].ks,strtoint(Edit2.text));
               Memo1.Append('doobjednal som: '
               +nedostatok[i].nazov+' ('
               +inttostr(nedostatok[i].kod)+') x '+inttostr(data[j].ks)
               +' -> '+inttostr(data[j].ks+strtoint(Edit2.text)));
             end;
            end;
      end;
    end;
  Memo1.Append('----------------------------------------------');
  RadioButton1.Checked:=true;
    If ((suhlas = true) and (CheckBox1.Checked=true)) or (CheckBox1.Checked=false) then
      begin
        CitanieStatistik;

        //1.2.1.Zapis do suboru STATISTIKY
        ID;
        For i:=1 to nNedostatok do
        begin
          inc(NStatistiky);
          statistiky[NStatistiky].typtransakcie:='N';
          statistiky[NStatistiky].IDtransakcie:=IDcislo;
          statistiky[NStatistiky].kod:=nedostatok[i].kod;
          statistiky[NStatistiky].ks:=nedostatok[i].ks;
          statistiky[NStatistiky].cenaSpolu:=nedostatok[i].cenaSpolu;
          ziskajDatum;
          statistiky[NStatistiky].datum:=datum;
        end;

        sub:='statistiky';
        verzie(sub);
        If predverziaStatistiky=verziaStatistiky then
        begin
          locky(sub);
          AssignFile(sStatistiky,Path+'statistiky.txt');
          Rewrite(sStatistiky);
          Writeln(sStatistiky,inttostr(NStatistiky));
          For i:=1 to NStatistiky do
            begin
             Writeln(sStatistiky,statistiky[i].typTransakcie+';'+statistiky[i].IDtransakcie
        +';'+inttostr(statistiky[i].kod)+';'+inttostr(statistiky[i].ks)
        +';'+inttostr(statistiky[i].cenaSpolu)+';'+statistiky[i].datum);
            end;
          CloseFile(sStatistiky);
          inc(predVerziaStatistiky);
          AssignFile(sStatistikyVerzia,Path+'statistiky_verzia.txt');
          Rewrite(sStatistikyVerzia);
          Writeln(sStatistikyVerzia,inttostr(predverziaStatistiky));
          CloseFile(sStatistikyVerzia);
          DeleteFile(Path+'STATISTIKY_LOCK.txt');
        end;

        //1.2.2.Zapis do suboru SKLAD
        sub:='sklad';
        verzie(sub);
        If predverziaSklad=verziaSklad then
        begin
          locky(sub);
          AssignFile(sSklad1,Path+'sklad.txt');
          Rewrite(sSklad1);
          Writeln(sSklad1,inttostr(nData));
          For i:=1 to nData do
            begin
             Writeln(sSklad1,inttostr(data[i].kod)+';'+inttostr(data[i].ks));
            end;
          CloseFile(sSklad1);
          inc(predVerziaSklad);
          AssignFile(sSkladVerzia,Path+'sklad_verzia.txt');
          Rewrite(sSkladVerzia);
          Writeln(sSkladVerzia,inttostr(predverziaSklad));
          CloseFile(sSkladVerzia);
          DeleteFile(Path+'SKLAD_LOCK.txt');
         end;
      end;
    end;
  end;

  //2.CISTENIE  -Data,Nedostatok
  cistenie;

  //3.Nacitanie dat: subor SKLAD
  sub:='sklad';
  Verzie(sub);
  If predverziaSklad<=verziaSklad then
   begin
    Locky(sub);
    AssignFile (sSklad2,Path+'sklad.txt');
    Reset (sSklad2);

    Readln(sSklad2,pom1);             //citanie riadku pocet poloziek
    pomNData:=strtoint(pom1);

    i:=0;
    While not eof(sSklad2) do        //citanie poloziek zo suboru do rekordu
    begin
      inc(i);
      Readln(sSklad2,pom1);
      trim(pom1);
      poz:=pos(';',pom1);
      pom2:=copy(pom1,1,poz-1);
      data[i].kod:=strtoint(pom2);
      delete(pom1,1,poz);
      data[i].ks:=strtoint(pom1);
    end;
    CloseFile(sSklad2);
    DeleteFile(Path+'SKLAD_LOCK.txt');
    predverziaSklad:=verziaSklad;

    //3.1.Kontrola citania dat
    If pomNData=i then nData:=pomNData else Memo1.Append('problem s nacitanim dat SKLAD');
  end;


  //4.Nacitanie dat: subor TOVAR
  //4.1.Nacitanie TOVAR
  sub:='tovar';
  Verzie(sub);
  If predverziaTovar<=verziaTovar then
   begin
    Locky(sub);
     AssignFile (sTovar,Path+'tovar.txt');
     Reset (sTovar);

     Readln(sTovar,pom1);             //citanie riadku pocet poloziek
     pomNData:=strtoint(pom1);

     i:=0;
     While not eof(sTovar) do        //citanie poloziek zo suboru do rekordu
     begin
       inc(i);
       Readln(sTovar,pom1);
       trim(pom1);
       poz:=pos(';',pom1);
       pom2:=copy(pom1,1,poz-1);
       tovar[i].kod:=strtoint(pom2);
       delete(pom1,1,poz);
       tovar[i].nazov:=pom1;
     end;
     CloseFile(sTovar);
     DeleteFile(Path+'TOVAR_LOCK.txt');
     predverziaTovar:=verziaTovar;

   //4.2.Kontrola citania dat
     If (pomNData=i) then nTovar:=i else Memo1.Append('problem s nacitanim dat TOVAR');
   end;

   //4.3.Priradenie nazvov z TOVAR do rekordu DATA
   bezNazvu:=0;
   For i:=1 to nData do
   begin
    j:=0;
    Repeat
     inc(j);
    until (data[i].kod = tovar[j].kod) or (j>=nTovar);
   If data[i].kod = tovar[j].kod then
   begin
     data[i].nazov:=tovar[j].nazov;
   end
   else
   begin
     inc(bezNazvu);
     data[i].nazov:=('bez nazvu'+inttostr(bezNazvu));
   end;
  end;

  //5.Nacitanie dat: subor CENNIK
  //5.1.Nacitanie CENNIK
  sub:='cennik';
  Verzie(sub);
  If predverziaCeny<=verziaCeny then
   begin
    Locky(sub);
    AssignFile (sCeny,Path+'cennik.txt');
    Reset (sCeny);
    Readln(sCeny,pom1);             //citanie riadku pocet poloziek
    pomNData:=strtoint(pom1);
    i:=0;
    While not eof(sCeny) do        //citanie poloziek zo suboru do rekordu
    begin
      Readln(sCeny,pom1);
      trim(pom1);
      If length(pom1)>4 then
      begin
        inc(i);
        poz:=pos(';',pom1);
        pom2:=copy(pom1,1,poz-1);
        ceny[i].kod:=strtoint(pom2);
        delete(pom1,1,poz);
        poz:=pos(';',pom1);
        delete(pom1,1,poz);
        ceny[i].cenaZaKs:=strtoint(pom1);
      end;
    end;
    CloseFile(sCeny);
    DeleteFile(Path+'CENNIK_LOCK.txt');
    predverziaCeny:=verziaCeny;

  //5.2.Kontrola citania dat
    If (pomNData=i)  then nCeny:=i else Memo1.Append('niektore tovary nemaju zadanu CENU');
   end;
   nCeny:=i;

  //5.3.Priradenie cien z CENY do rekordu DATA
  i:=0;
  Repeat
   inc(i);
   j:=0;
     Repeat
      inc(j);
     until (data[i].kod = ceny[j].kod) or (j>=nCeny);
    If data[i].kod = ceny[j].kod then
    begin
      data[i].cenaZaKs:=ceny[j].cenaZaKs;
    end
    else
    begin
      data[nData+1]:=data[n];
      For k:= i to nData do
      begin
        data[k]:=data[k+1];
      end;
      dec(nData);
      dec(i);
    end;
  until i>=nData ;

 //6.Priradenie dat z DATA do ZOBRAZENE
  For i:=1 to nZobrazene do
  begin
   zhoda:=0;
   j:=0;
      Repeat
       inc(j);
       If data[j].kod = zobrazene[i].kod then zhoda:=1;
      until (j>=nData) or (zhoda=1);

      case zhoda of
        0:
          begin
           zobrazene[nZobrazene+1].kod:=0;           //vycistenie poslednej
           zobrazene[nZobrazene+1].nazov:='';
           zobrazene[nZobrazene+1].ks:=0;
           zobrazene[nZobrazene+1].cenaZaKs:=0;

           For k:=i to nZobrazene do                //odstranenie uz neexistujuceho tovaru
            begin
              zobrazene[k].kod:=zobrazene[k+1].kod;
              zobrazene[k].nazov:=zobrazene[k+1].nazov;
              zobrazene[k].ks:=zobrazene[k+1].ks;
              zobrazene[k].cenaZaKs:=zobrazene[k+1].cenaZaKs;
            end;
            dec(nZobrazene);
          end;
        1:
          begin
            zobrazene[i].nazov:=data[j].nazov;
            zobrazene[i].ks:=data[j].ks;
            zobrazene[i].cenaZaKs:=data[j].cenaZaKs;
          end;
      end;
     end;

 //7.Vykreslenie obsahu StringGrid1 AKTUALNY STAV
   If nZobrazene >0 then
   begin
     StringGrid1.RowCount:=nZobrazene+1;
     For i:=1 to nZobrazene do
     begin
         StringGrid1.Cells[1,i]:=inttostr(zobrazene[i].kod);
         StringGrid1.Cells[2,i]:=zobrazene[i].nazov;
         StringGrid1.Cells[3,i]:=inttostr(zobrazene[i].ks);
         StringGrid1.Cells[0,i]:=inttostr(i);
     end;
   end;

 //8.Vykreslenie StringGrid2 OBJEDNAVKA
 If nObjednavka>0 then
  begin
  StringGrid2.RowCount:=nObjednavka+1;
    For i:=1 to nObjednavka do
    begin
        StringGrid2.Cells[1,i]:=objednavka[i].nazov;
        StringGrid2.Cells[2,i]:=inttostr(objednavka[i].ks);
        ZobrazenieCeny(objednavka[i].cenaZaKs);
        StringGrid2.Cells[3,i]:=c1;
        ZobrazenieCeny(objednavka[i].cenaSpolu);
        StringGrid2.Cells[4,i]:=c1;
        StringGrid2.Cells[0,i]:=inttostr(i);
    end;
  Button2.Enabled:=true;
  end;
end;

procedure TForm1.CitanieStatistik;
var i,poz,pomNStatistiky:integer;
    pom1,pom2,sub:string;
begin
 //C*i*t*a*n*i*e subor STATISTIKY
 sub:='statistiky';
 Verzie(sub);
 If predverziaStatistiky<=verziaStatistiky then
   begin
    Locky(sub);
    AssignFile(sStatistiky,Path+'statistiky.txt');
    Reset(sStatistiky);

    Readln(sStatistiky,pom1);             //citanie riadku pocet poloziek
    pomNStatistiky:=strtoint(pom1);

    i:=0;
    While not eof(sStatistiky) do        //citanie poloziek zo suboru do rekordu
    begin
      inc(i);
      Readln(sStatistiky,pom1);
      trim(pom1);

      statistiky[i].typTransakcie:=pom1[1];
      delete(pom1,1,2);

      poz:=pos(';',pom1);               //citanie udaju ID transakcie
      pom2:=copy(pom1,1,poz-1);
      statistiky[i].IDtransakcie:=pom2;
      delete(pom1,1,poz);

      poz:=pos(';',pom1);               //citanie udaju Kod
      pom2:=copy(pom1,1,poz-1);
      statistiky[i].kod:=strtoint(pom2);
      delete(pom1,1,poz);

      poz:=pos(';',pom1);               //citanie udaju Pocet ks
      pom2:=copy(pom1,1,poz-1);
      statistiky[i].ks:=strtoint(pom2);
      delete(pom1,1,poz);

      poz:=pos(';',pom1);               //citanie udaju CenaSpolu
      pom2:=copy(pom1,1,poz-1);
      statistiky[i].cenaSpolu:=strtoint(pom2);
      delete(pom1,1,poz);

      statistiky[i].datum:=pom1;        //citanie udaju Datum
    end;
    CloseFile(sStatistiky);
    DeleteFile(Path+'STATISTIKY_LOCK.txt');
    predverziaStatistiky:=verziaStatistiky;

   //Kontrola citania dat
   If pomNStatistiky = i then NStatistiky:=pomNStatistiky else
   Memo1.Append('problem s nacitanim dat STATISTIKY');
 end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var i,j,k,zhoda:integer;
    pomTypObj,sub:string;
begin
 //N*A*K*U*P T*O*V*A*R*U
  pomTypObj:= 'Manualnej objednavky';
  DisplayMessageBox(nObjednavka,pomTypObj);
  If suhlas = true then
  begin
    NStatistiky:=0;
    CitanieStatistik;
  ID;
  For i:=1 to nObjednavka do
    begin
    inc(NStatistiky);
    statistiky[NStatistiky].typTransakcie:='N';
    statistiky[NStatistiky].IDtransakcie:=IDcislo;
    statistiky[NStatistiky].kod:=objednavka[i].kod;
    statistiky[NStatistiky].ks:=objednavka[i].ks;
    statistiky[NStatistiky].cenaSpolu:=objednavka[i].cenaSpolu;
    ziskajDatum;
    statistiky[NStatistiky].datum:=datum;
    end;

  //1.Prepisanie suboru STATISTIKY
    sub:='statistiky';
    verzie(sub);
    If predverziaStatistiky=verziaStatistiky then
    begin
      locky(sub);
      AssignFile(sStatistiky,Path+'statistiky.txt');
      Rewrite(sStatistiky);
      Writeln(sStatistiky,inttostr(NStatistiky));
      For i:=1 to NStatistiky do
        begin
         Writeln(sStatistiky,statistiky[i].typTransakcie+';'+statistiky[i].IDtransakcie
      +';'+inttostr(statistiky[i].kod)+';'+inttostr(statistiky[i].ks)
      +';'+inttostr(statistiky[i].cenaSpolu)+';'+statistiky[i].datum);
        end;
      CloseFile(sStatistiky);
      inc(predVerziaStatistiky);
      AssignFile(sStatistikyVerzia,Path+'statistiky_verzia.txt');
      Rewrite(sStatistikyVerzia);
      Writeln(sStatistikyVerzia,inttostr(predverziaStatistiky));
      CloseFile(sStatistikyVerzia);
      DeleteFile(Path+'STATISTIKY_LOCK.txt');
  end;

   //2.Porovnanie objednavky z aktualnou databazou
    For j:=1 to nObjednavka do
    begin
      For i:=1 to nData do
      begin
       If objednavka[j].kod = data[i].kod then
       begin
         inc(data[i].ks);
       end;
      end;
    end;

    //3.Prepisanie suboru SKLAD
    sub:='sklad';
    verzie(sub);
    If predverziaSklad=verziaSklad then
    begin
      locky(sub);
      AssignFile(sSklad1,Path+'sklad.txt');

      Rewrite(sSklad1);
      Writeln(sSklad1,inttostr(nData));
      For i:=1 to nData do
        begin
         Writeln(sSklad1,inttostr(data[i].kod)+';'+inttostr(data[i].ks));
        end;
      CloseFile(sSklad1);
      inc(predVerziaSklad);
      AssignFile(sSkladVerzia,Path+'sklad_verzia.txt');
      Rewrite(sSkladVerzia);
      Writeln(sSkladVerzia,inttostr(predverziaSklad));
      CloseFile(sSkladVerzia);
      DeleteFile(Path+'SKLAD_LOCK.txt');
    end;

    //4.Priradenie dat z DATA do ZOBRAZENE
    For i:=1 to nZobrazene do
    begin
     zhoda:=0;
     j:=0;
        Repeat
         inc(j);
         If data[j].kod = zobrazene[i].kod then zhoda:=1;
        until (j>=nData) or (zhoda=1);

        case zhoda of
          0:
            begin
             zobrazene[nZobrazene+1].kod:=0;           //vycistenie poslednej
             zobrazene[nZobrazene+1].nazov:='';
             zobrazene[nZobrazene+1].ks:=0;
             zobrazene[nZobrazene+1].cenaZaKs:=0;

             For k:=i to nZobrazene do                //odstranenie uz neexistujuceho tovaru
              begin
                zobrazene[k].kod:=zobrazene[k+1].kod;
                zobrazene[k].nazov:=zobrazene[k+1].nazov;
                zobrazene[k].ks:=zobrazene[k+1].ks;
                zobrazene[k].cenaZaKs:=zobrazene[k+1].cenaZaKs;
              end;
              dec(nZobrazene);
            end;
          1:
            begin
              zobrazene[i].nazov:=data[j].nazov;
              zobrazene[i].ks:=data[j].ks;
              zobrazene[i].cenaZaKs:=data[j].cenaZaKs;
            end;
        end;
       end;

    //5.Vykreslenie obsahu StringGrid1 AKTUALNY STAV
     If nZobrazene >0 then
     begin
       StringGrid1.RowCount:=nZobrazene+1;
       For i:=1 to nZobrazene do
       begin
           StringGrid1.Cells[1,i]:=inttostr(zobrazene[i].kod);
           StringGrid1.Cells[2,i]:=zobrazene[i].nazov;
           StringGrid1.Cells[3,i]:=inttostr(zobrazene[i].ks);
           StringGrid1.Cells[0,i]:=inttostr(i);
       end;
     end;

    //6.Vyprazdnenie kosika
    If nObjednavka>0 then
    begin
      nObjednavka:=0;
      For i:=1 to n do
      begin
        objednavka[i].kod:=0;
        objednavka[i].nazov:='';
        objednavka[i].ks:=0;
        objednavka[i].cenaZaKs:=0;
        objednavka[i].cenaspolu:=0;
      end;
    end;

    //7.Vykreslenie StringGrid2 OBJEDNAVKA
    StringGrid2.RowCount:=nObjednavka+1;

    Button2.Enabled:=false;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var i,k,zhoda:integer;
begin
  //O*B*J*E*D*N*A*T V*S*E*T*K*O zobrazene
  If nZobrazene>0 then
  begin
    For k:=1 to nZobrazene do
    begin
      zhoda:=0;
      i:=0;
      Repeat                   //Kontrola, ci uz vybrany artikel je v Objednavke
       inc(i);
       If zobrazene[k].kod = objednavka[i].kod then zhoda:=1;
      until (i>=nObjednavka) or (zhoda=1);

      case zhoda of
        0:
          begin
            objednavka[nObjednavka+1].kod:=zobrazene[k].kod;
            objednavka[nObjednavka+1].nazov:=zobrazene[k].nazov;
            objednavka[nObjednavka+1].ks:=1;
            objednavka[nObjednavka+1].cenaZaKs:=zobrazene[k].cenaZaKs;
            objednavka[nObjednavka+1].cenaSpolu:=
            (objednavka[nObjednavka+1].ks)*(objednavka[nObjednavka+1].cenaZaKs);
            inc(nObjednavka);
            Memo1.Append('pridanie do objednavky: '
            +objednavka[nObjednavka].nazov+' ('
            +inttostr(objednavka[nObjednavka].kod)+') x'
            +inttostr(objednavka[nObjednavka].ks));
          end;
        1:
          begin
            inc(objednavka[i].ks);
            objednavka[i].cenaSpolu:=(objednavka[i].ks)*(objednavka[i].cenaZaKs);
            Memo1.Append('zvysenie mnozstva: '+objednavka[i].nazov+' ('
            +inttostr(objednavka[i].kod)+') x'+inttostr(objednavka[i].ks-1)
            +' -> '+inttostr(objednavka[i].ks));
          end;
      end;
    end;

      //Vykreslenie StringGrid2
       If nObjednavka>0 then
       begin
       StringGrid2.RowCount:=nObjednavka+1;
       For i:=1 to nObjednavka do
        begin
            StringGrid2.Cells[1,i]:=objednavka[i].nazov;
            StringGrid2.Cells[2,i]:=inttostr(objednavka[i].ks);
            ZobrazenieCeny(objednavka[i].cenaZaKs);
            StringGrid2.Cells[3,i]:=c1;
            ZobrazenieCeny(objednavka[i].cenaSpolu);
            StringGrid2.Cells[4,i]:=c1;
            StringGrid2.Cells[0,i]:=inttostr(i);
        end;
        Button2.Enabled:=true;
       end;
  end;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  If CheckBox2.Checked = true then
  begin
   CheckBox2.Checked:=true;
   CheckBox3.Checked:=true;
   CheckBox4.Checked:=true;
   CheckBox5.Checked:=true;
   CheckBox6.Checked:=true;
   CheckBox7.Checked:=true;
  end;

  vyberKategorii;
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
 If CheckBox3.Checked = false then CheckBox2.Checked:=false;
 vyberKategorii;
end;

procedure TForm1.CheckBox4Change(Sender: TObject);
begin
 If CheckBox4.Checked = false then CheckBox2.Checked:=false;
 VyberKategorii;
end;

procedure TForm1.CheckBox5Change(Sender: TObject);
begin
 If CheckBox5.Checked = false then CheckBox2.Checked:=false;
 VyberKategorii;
end;

procedure TForm1.CheckBox6Change(Sender: TObject);
begin
  If CheckBox6.Checked = false then CheckBox2.Checked:=false;
  VyberKategorii;
end;

procedure TForm1.CheckBox7Change(Sender: TObject);
begin
  If CheckBox7.Checked = false then CheckBox2.Checked:=false;
  VyberKategorii;
end;

procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
begin
  //V*Y*P*R*A*Z*D*N*E*N*I*E K*O*S*I*K*A
  If nObjednavka>0 then
  begin
    nObjednavka:=0;
    For i:=1 to n do
    begin
      objednavka[i].kod:=0;
      objednavka[i].nazov:='';
      objednavka[i].ks:=0;
      objednavka[i].cenaZaKs:=0;
      objednavka[i].cenaspolu:=0;
    end;
    Memo1.Append('vasa objednavka bola zrusena');
  end;

    //Vykreslenie StringGrid2 OBJEDNAVKA
  StringGrid2.RowCount:=nObjednavka+1;

  Button2.Enabled:=false;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  zorad;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  If Edit1.Text='' then Edit1.Text:='0';
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  If Edit2.Text='' then Edit2.Text:='0';
end;

procedure TForm1.Edit3EditingDone(Sender: TObject);
var i,zhoda:integer;
    pom:string;
begin
  //V*Y*H*L*A*D*A*V*A*N*I*E artiklu

  //1.Vyhladavanie najprv rec ZOBRAZENE
  i:=0;
  zhoda:=0;
  Repeat
  inc(i);
  pom:=inttostr(zobrazene[i].kod);
  If pom[1..length(Edit3.text)] = Edit3.text then
      begin
        inc(zhoda);
        StringGrid1.Row:=i;
        //i:=nZobrazene;
      end
    else
      begin
      If zobrazene[i].nazov[1..length(Edit3.text)] = Edit3.text then
        begin
          inc(zhoda);
          StringGrid1.Row:=i;
          //i:=nZobrazene;
        end;
      end;
  until i>=nZobrazene;
  If zhoda>0 then Memo1.Append('Vyhladavanie| pocet najdenych vysledkov: '+inttostr(zhoda))

  //2.Vyhladavanie v celom poli DATA
  else
  begin
    i:=0;
    zhoda:=0;
    Repeat
    inc(i);
    pom:=inttostr(data[i].kod);
    If pom[1..length(Edit3.text)] = Edit3.text then
        begin
          inc(zhoda);
          StringGrid1.Row:=i;
        //i:=nData;
        end
      else
        begin
        If data[i].nazov[1..length(Edit3.text)] = Edit3.text then
          begin
            inc(zhoda);
            StringGrid1.Row:=i;
            //i:=nData;
          end;
        end;
    until i>=nData;
    If zhoda<=0 then
      begin
         Edit3.text:='ziadna zhoda';
         Memo1.Append('Vyhladavanie| ziadna zhoda');
      end
    else
      begin
         Memo1.Append('Vyhladavanie| pocet najdenych vysledkov: '+inttostr(zhoda));
         CheckBox2.Checked:=true;
      end;
end;
end;

procedure TForm1.Edit4EditingDone(Sender: TObject);
begin
  If CheckBox6.Checked=true then VyberKategorii;
end;

procedure TForm1.Image1Click(Sender: TObject);
var i:integer;
begin
 //V*Y*P*R*A*Z*D*N*E*N*I*E K*O*S*I*K*A
  If nObjednavka>0 then
  begin
    nObjednavka:=0;
    For i:=1 to n do
    begin
      objednavka[i].kod:=0;
      objednavka[i].nazov:='';
      objednavka[i].ks:=0;
      objednavka[i].cenaZaKs:=0;
      objednavka[i].cenaspolu:=0;
    end;
    Memo1.Clear;
    Memo1.Append('vasa objednavka bola zrusena');
  end;

    //Vykreslenie StringGrid2 OBJEDNAVKA
  StringGrid2.RowCount:=nObjednavka+1;

  Button2.Enabled:=false;
end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
 //A*U*T*O*M*A*T*I*C*K*A O*B*J*E*D*N*A*V*K*A
  If RadioButton1.Checked = true then
  begin
   CheckBox1.Enabled:=true;
   Label2.Enabled:=true;
   Label6.Enabled:=true;
   Edit1.Enabled:=true;
   Edit2.Enabled:=true;
  end;
end;

procedure TForm1.DisplayMessageBox(nArtiklov:integer; typObjednavky:string);
var
  Odpoved, BoxStyle: Integer;
  pomMsg,pomTit:string;
begin                                               //Artiklov=nObjednavka alebo nNedostatok
  pomMsg:='Naozaj chcete objednat tieto artikle ('+inttostr(nArtiklov)+') ?';
  pomTit:='Potvrdenie '+typObjednavky;
  BoxStyle := MB_IconQuestion + MB_YesNo;
  Odpoved := Application.MessageBox(pchar(pomMsg),pchar(pomTit), BoxStyle);
  if Odpoved = IDYES then
    begin
      Application.MessageBox('Objednavka bola uspesne vykonana. ',
      'Potvrdenie objednavky',MB_ICONINFORMATION);
      suhlas:=true;
    end
  else
    begin
      Application.MessageBox('Nepotvrdili ste objednavku. Vasa objednavka bude teraz zrusena.',
      'Zrusenie objednavky', MB_ICONHAND);
      suhlas:=false;
      Memo1.Append('objednavka bola zrusena');
    end;
end;

procedure TForm1.VyberKategorii();
var i,j,zhoda:integer;
begin
  //Z*O*B*R*A*Z*E*N*I*E podla kategorii
  //1.Cistenie rekord ZOBRAZENE
  nZobrazene:=0;
  For i:=1 to n do
  begin
    zobrazene[i].kod:=0;
    zobrazene[i].nazov:='';
    zobrazene[i].ks:=0;
    zobrazene[i].cenaZaKs:=0;
  end;

  //2.Vyhodnotenie jednotlivych kategorii
  If CheckBox2.Checked = true then            //vsetko zobrazene
   begin
    nZobrazene:=nData;
    For i:=1 to nZobrazene do
    begin
      zobrazene[i].kod:=data[i].kod;
      zobrazene[i].nazov:=data[i].nazov;
      zobrazene[i].ks:=data[i].ks;
      zobrazene[i].cenaZaKs:=data[i].cenaZaKs;
    end;
   end
  else
  begin
    If CheckBox3.Checked = true then         //kat1
    begin
     zobraz('1');
    end;

    If CheckBox4.Checked = true then         //kat2
    begin
     zobraz('2');
    end;

    If CheckBox5.Checked = true then         //kat3
    begin
     zobraz('3');
    end;

    If CheckBox7.Checked = true then         //kat4
    begin
     zobraz('4');
    end;

    If CheckBox6.Checked = true then         //menej ako
    begin
     For i:=1 to nData do
     begin
     If data[i].ks <= (strtoint(Edit4.text)) then
       begin
         If nZobrazene>0 then
              begin
                  zhoda:=0;
                  j:=0;
                  Repeat
                   inc(j);
                   If data[i].kod = zobrazene[j].kod then zhoda:=1;
                  until (j>=nZobrazene) or (zhoda>=1);

                  If zhoda = 0 then
                      begin
                        zobrazene[nZobrazene+1].kod:=data[i].kod;
                        zobrazene[nZobrazene+1].nazov:=data[i].nazov;
                        zobrazene[nZobrazene+1].ks:=data[i].ks;
                        zobrazene[nZobrazene+1].cenaZaKs:=data[i].cenaZaKs;
                        inc(nZobrazene);
                      end;
               end
              else
               begin
                zobrazene[1].kod:=data[i].kod;
                zobrazene[1].nazov:=data[i].nazov;
                zobrazene[1].ks:=data[i].ks;
                zobrazene[1].cenaZaKs:=data[i].cenaZaKs;
                inc(nZobrazene);
               end;
       end;
      end;
     end;
  end;

  //3.Zoradenie a vykreslenie StrinGrid1 AKTUALNY stav
  zorad;

end;

procedure TForm1.Locky(nazovSuboru:string);
var  kontrolna:boolean;
begin
  kontrolna:=true;
  While kontrolna = true do
  begin
   case nazovSuboru of
     'tovar': If not FileExists (Path+'TOVAR_LOCK.txt') then
       begin
         AssignFile(sTovarLock,Path+'TOVAR_LOCK.txt');
         Rewrite(sTovarLock);
         kontrolna:=false;
         CloseFile(sTovarLock);
       end;
     'cennik': If not FileExists (Path+'CENNIK_LOCK.txt') then
       begin
         AssignFile(sCenyLock,Path+'CENNIK_LOCK.txt');
         Rewrite(sCenyLock);
         kontrolna:=false;
         CloseFile(sCenyLock);
       end;
     'statistiky': If not FileExists (Path+'STATISTIKY_LOCK.txt') then
       begin
         AssignFile(sStatistikyLock,Path+'STATISTIKY_LOCK.txt');
         Rewrite(sStatistikyLock);
         kontrolna:=false;
         CloseFile(sStatistikyLock);
       end;
      'sklad': If not FileExists (Path+'SKLAD_LOCK.txt') then
       begin
         AssignFile(sSkladLock,Path+'SKLAD_LOCK.txt');
         Rewrite(sSkladLock);
         kontrolna:=false;
         CloseFile(sSkladLock);
       end;
   end;
  end;
end;

procedure TForm1.Verzie(nazovSuboru:string);
var pom:string;
begin
  case nazovSuboru of
     'tovar':
       begin
         AssignFile(sTovarVerzia,Path+'TOVAR_VERZIA.txt');
         Reset(sTovarVerzia);
         Readln(sTovarVerzia,pom);
         verziaTovar:=strtoint(pom);
         CloseFile(sTovarVerzia);
       end;
     'sklad':
       begin
         AssignFile(sSKladVerzia,Path+'SKLAD_VERZIA.txt');
         Reset(sSKladVerzia);
         Readln(sSKladVerzia,pom);
         verziaSklad:=strtoint(pom);
         CloseFile(sSKladVerzia);
       end;
     'cennik':
       begin
         AssignFile(sCenyVerzia,Path+'CENNIK_VERZIA.txt');
         Reset(sCenyVerzia);
         Readln(sCenyVerzia,pom);
         verziaCeny:=strtoint(pom);
         CloseFile(sCenyVerzia);
       end;
     'statistiky':
       begin
         AssignFile(sStatistikyVerzia,Path+'STATISTIKY_VERZIA.txt');
         Reset(sStatistikyVerzia);
         Readln(sStatistikyVerzia,pom);
         verziaStatistiky:=strtoint(pom);
         CloseFile(sStatistikyVerzia);
       end;
  end;
end;

procedure TForm1.ZobrazenieCeny(premienanaCena:integer);
var c:string;
begin
  c:=inttostr(premienanaCena);
  case length(c) of
  0: c1:='0';
  1: c1:='0.0'+c;
  2: c1:='0.'+c;
  3,4,5,6:
    begin
    c1:=copy(c,1,(length(c)-2));
    delete(c,1,(length(c)-2));
    c1:=c1+'.'+c;
  end;
 end;
end;

procedure TForm1.ZiskajDatum();
var den,mesiac,rok,pom:string;
begin
  pom:=DateTimeToStr(DATE); //31.12.1099
  den:=copy(pom,1,(pos('.',pom)-1));
  Delete(pom,1,pos('.',pom));
  mesiac:=copy(pom,2,pos('.',pom)-1-1);
  Delete(pom,1,pos('.',pom));
  rok:=Copy(pom,4,2);


  if StrToInt(den) < 10 then den:='0'+den;
  if StrToInt(mesiac) < 10 then mesiac:='0'+mesiac;
  if StrToInt(rok) < 10 then rok:='0'+rok;
  datum:=rok+mesiac+den;
end;

procedure TForm1.ID();
var i,j,zhoda,cislo:integer;
begin
  Repeat
   IDcislo:='';
   For i:=1 to 8 do
    begin
     cislo:=random(10);
     IDcislo:=IDcislo+inttostr(cislo);
    end;
    zhoda:=0;
    j:=0;
    Repeat
     inc(j);
     If Statistiky[j].IDtransakcie = IDcislo then zhoda:=1;
    until (j>=NStatistiky-1) or (zhoda=1);
  until (zhoda=0);
end;

end.
