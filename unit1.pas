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
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
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
    procedure Edit1EditingDone(Sender: TObject);
    procedure Edit3EditingDone(Sender: TObject);
    procedure Edit4EditingDone(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure Cistenie ();
    procedure Zobraz(kategoria:string);
    procedure Zorad ();
    procedure VyberKategorii();
    procedure CitanieStatistik ();
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
    kod,ks,cenaZaKs:integer;
    IDtransakcie:string;
    end;
const n=9;
const m=50;

var
  sSklad1,sSklad2,sTovar,sCeny,sStatistiky,sKategorie:textfile;
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
  stlpecZobrazene,stlpecObjednavka:integer;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i,j,k,poz,pomNData,pomNKategorie,bezNazvu:integer;
    pom1,pom2:string;
begin
  {StringGrid1.RowCount:=7;
  StringGrid1.Cells[1,2]:='g';  //stlpec, riadok
  stringgrid1.deletecol(i);
  stringgrid1.deleterow(i);
  stringgrid1.deletecol(i);
  var
  I : Integer;
  Lines : TStringList;
...
for I := 0 to Lines.Count - 1 do
  PopupNotifier1.Text := PopupNotifier1.Text + LineEnding + Lines[I];
  PopupNotifier1.Visible: Boolean;

  }
  { TODO -oDanka -cmaslo : Danka: Aha... Zaujimave >:D }


  //1.Cistenie  -Memo,Data,Nedostatok,Zobrazene,Objednavka
  Cistenie;
  Memo1.Clear;
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


   //2.Nacitanie dat: subor SKLAD

   AssignFile (sSklad2,'sklad.txt');
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

   If pomNData=i then           //kontrola citania dat
   begin
    nData:=pomNData;
   end
   else
    Memo1.Append('problem s nacitanim dat SKLAD');


   //3.Nacitanie dat: subor TOVAR
   //3.1.Nacitanie TOVAR
   AssignFile (sTovar,'tovar.txt');
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

   If (pomNData=i) then           //kontrola citania dat
   begin
    nTovar:=i;
   end
   else
     Memo1.Append('problem s nacitanim dat TOVAR');


   //3.2.Priradenie nazvov z TOVAR do rekordu DATA
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
  AssignFile (sCeny,'cennik.txt');
  Reset (sCeny);

  Readln(sCeny,pom1);             //citanie riadku pocet poloziek
  pomNData:=strtoint(pom1);

  i:=0;
  While not eof(sCeny) do        //citanie poloziek zo suboru do rekordu
  begin
    inc(i);
    Readln(sCeny,pom1);
    trim(pom1);
    poz:=pos(';',pom1);
    pom2:=copy(pom1,1,poz-1);
    ceny[i].kod:=strtoint(pom2);
    delete(pom1,1,poz);
    poz:=pos(';',pom1);
    delete(pom1,1,poz);
    ceny[i].cenaZaKs:=strtoint(pom1);
  end;
  CloseFile(sCeny);

  If (pomNData=i)  then                             //kontrola citania dat
  begin
   nCeny:=i;
  end
  else
   Memo1.Append('niektore tovary nemaju zadanu CENU');


  //4.2.Priradenie cien z CENY do rekordu DATA
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

  Readln(sKategorie,pom1);
  pomNKategorie:=strtoint(pom1);
  if pomNKategorie = 4 then
  begin
    i:=0;
    While not eof(sKategorie) do
      begin
        inc(i);
        Readln(sKategorie,pom1);
        poz:=pos(';',pom1);
        pom2:=copy(pom1,1,poz-1);
        delete(pom1,1,poz);
        kategorie[strtoint(pom2)]:=pom1;
      end;

  //7.2.Priradenie kategorii na CheckBoxy
  CheckBox3.Caption:=kategorie[1];
  CheckBox4.Caption:=kategorie[2];
  CheckBox5.Caption:=kategorie[3];
  CheckBox7.Caption:=kategorie[4];
  end;

  //8.Vykreslenie obsahu StringGrid1 AKTUALNY STAV
  VyberKategorii;
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
  until (i>=nObjednavka) or (zhoda=1);

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
        StringGrid2.Cells[3,i]:=inttostr(objednavka[i].cenaZaKs);
        StringGrid2.Cells[4,i]:=inttostr(objednavka[i].cenaSpolu);
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
 StringGrid1.Canvas.Brush.color:=clAqua;
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
    StringGrid2.deleteRow(riadokObjednavka);

    Memo1.Append('uprava mnozstva: '+objednavka[riadokObjednavka].nazov+' ('
    +inttostr(objednavka[riadokObjednavka].kod)+') x '
    +inttostr(objednavka[riadokObjednavka].ks)
    +' -> '+inttostr(objednavka[riadokObjednavka].ks-1));

    For i:=riadokObjednavka to nObjednavka do
    begin
      objednavka[i].kod:=objednavka[i+1].kod;
      objednavka[i].nazov:=objednavka[i+1].nazov;
      objednavka[i].ks:=objednavka[i+1].ks;
      objednavka[i].cenaZaKs:=objednavka[i+1].cenaZaKs;
      objednavka[i].cenaspolu:=objednavka[i+1].cenaspolu;
    end;
    dec(nObjednavka);

    For i:=1 to nObjednavka do
    begin
     StringGrid2.Cells[0,i]:=inttostr(i);
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
     pom:=inttostr(objednavka[riadokObjednavka].ks);
     objednavka[riadokObjednavka].ks:=strtoint(StringGrid2.Cells[stlpecObjednavka,riadokObjednavka]);
     objednavka[riadokObjednavka].cenaSpolu:=(objednavka[riadokObjednavka].ks)*
     (objednavka[riadokObjednavka].cenaZaKs);
     Memo1.Append('uprava mnozstva: '+objednavka[riadokObjednavka].nazov+' ('
    +inttostr(objednavka[riadokObjednavka].kod)+') x '
    +pom+' -> '+StringGrid2.Cells[stlpecObjednavka,riadokObjednavka]);

     //Vykreslenie StringGrid2 OBJEDNAVKA
     StringGrid2.RowCount:=nObjednavka+1;
      For i:=1 to nObjednavka do
      begin
          StringGrid2.Cells[1,i]:=objednavka[i].nazov;
          StringGrid2.Cells[2,i]:=inttostr(objednavka[i].ks);
          StringGrid2.Cells[3,i]:=inttostr(objednavka[i].cenaZaKs);
          StringGrid2.Cells[4,i]:=inttostr(objednavka[i].cenaSpolu);
          StringGrid2.Cells[0,i]:=inttostr(i);
      end;
     end;
 end;

 //Kontrola pocet kusov v objednavke=0
 If objednavka[riadokObjednavka].ks<=0 then
  begin
  StringGrid2.deleteRow(riadokObjednavka);
    for i:=riadokObjednavka to nObjednavka do
    begin
      objednavka[i].kod:=objednavka[i+1].kod;
      objednavka[i].nazov:=objednavka[i+1].nazov;
      objednavka[i].ks:=objednavka[i+1].ks;
      objednavka[i].cenaZaKs:=objednavka[i+1].cenaZaKs;
      objednavka[i].cenaspolu:=objednavka[i+1].cenaspolu;
    end;
   dec(nobjednavka);
  end;

end;

procedure TForm1.StringGrid2PrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
begin
 if gdFixed in aState then exit;
 if (aRow = StringGrid2.Row) then
 StringGrid2.Canvas.Brush.color:=clOlive;
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
    pom1,pom2,pomTypObj:string;
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
    If data[i].ks <= (strtoint(Edit1.text)) then
       begin
        inc(nNedostatok);
        nedostatok[nNedostatok].kod:=data[i].kod;
        nedostatok[nNedostatok].nazov:=data[i].nazov;
        nedostatok[nNedostatok].ks:=strtoint(Edit2.text);
        nedostatok[nNedostatok].cenaZaKs:=data[i].cenaZaKs;
        nedostatok[nNedostatok].cenaSpolu:=((nedostatok[nNedostatok].ks)*(nedostatok[nNedostatok].cenaZaKs));


         Memo1.Append('doobjednavam: '
        +nedostatok[nNedostatok].nazov+' ('
        +inttostr(nedostatok[nNedostatok].kod)+') x '+inttostr(data[i].ks)
        +' -> '+inttostr(data[i].ks+strtoint(Edit2.text)));

        If CheckBox1.Checked = false then inc(data[i].ks,strtoint(Edit2.text));
        end;
    end;
  Memo1.Append('----------------------------------------------');

  //1.2.Nakup
  If CheckBox1.Checked=true then
  begin
    pomTypObj:='Automatickej objednavky';
    DisplayMessageBox(nNedostatok,pomTypObj);

    If suhlas = true then
    begin
      CitanieStatistik;

      //1.2.1.Zapis do suboru SATISTIKY
      For i:=1 to nNedostatok do
      begin
        inc(NStatistiky);
        statistiky[NStatistiky].IDtransakcie:='N'+'12345678';
        statistiky[NStatistiky].kod:=nedostatok[i].kod;
        statistiky[NStatistiky].ks:=nedostatok[i].ks;
        statistiky[NStatistiky].cenaZaKs:=nedostatok[i].cenaZaKs;
      end;

      AssignFile(sStatistiky,'statistiky.txt');
      Rewrite(sStatistiky);
      Writeln(sStatistiky,inttostr(NStatistiky));
      For i:=1 to NStatistiky do
        begin
         Writeln(sStatistiky,statistiky[i].IDtransakcie+';'+
         inttostr(statistiky[i].kod)+';'+inttostr(statistiky[i].ks)+';'
         +inttostr(statistiky[i].cenaZaKs));
        end;
      CloseFile(sStatistiky);

      //1.2.2.Zapis do suboru SKLAD
      AssignFile(sSklad1,'sklad.txt');
      Rewrite(sSklad1);
      Writeln(sSklad1,inttostr(nData));
      For i:=1 to nData do
        begin
         Writeln(sSklad1,inttostr(data[i].kod)+';'+inttostr(data[i].ks));
        end;
      CloseFile(sSklad1);
     end;
  end;

  //2.CISTENIE  -Data,Nedostatok
  end;
  cistenie;

  //3.Nacitanie dat: subor SKLAD
  AssignFile (sSklad2,'sklad.txt');
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

  If pomNData=i then            //kontrola citania dat
  begin
   nData:=pomNData;
  end
  else
   Memo1.Append('problem s nacitanim dat SKLAD');


  //4.Nacitanie dat: subor TOVAR
  //4.1.Nacitanie TOVAR
   AssignFile (sTovar,'tovar.txt');
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

   If (pomNData=i) then           //kontrola citania dat
   begin
    nTovar:=i;
   end
   else
     Memo1.Append('problem s nacitanim dat TOVAR');


   //4.2.Priradenie nazvov z TOVAR do rekordu DATA
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
  AssignFile (sCeny,'cennik.txt');
  Reset (sCeny);

  Readln(sCeny,pom1);             //citanie riadku pocet poloziek
  pomNData:=strtoint(pom1);

  i:=0;
  While not eof(sCeny) do        //citanie poloziek zo suboru do rekordu
  begin
    inc(i);
    Readln(sCeny,pom1);
    trim(pom1);
    poz:=pos(';',pom1);
    pom2:=copy(pom1,1,poz-1);
    ceny[i].kod:=strtoint(pom2);
    delete(pom1,1,poz);
    poz:=pos(';',pom1);
    delete(pom1,1,poz);
    ceny[i].cenaZaKs:=strtoint(pom1);
  end;
  CloseFile(sCeny);

  If (pomNData=i)  then         //kontrola citania dat
  begin
   nCeny:=i;
  end
  else
   Memo1.Append('niektore tovary nemaju zadanu CENU');

  //5.2.Priradenie cien z CENY do rekordu DATA
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
        StringGrid2.Cells[3,i]:=inttostr(objednavka[i].cenaZaKs);
        StringGrid2.Cells[4,i]:=inttostr(objednavka[i].cenaSpolu);
        StringGrid2.Cells[0,i]:=inttostr(i);
    end;
  Button2.Enabled:=true;
  end;
end;

procedure TForm1.CitanieStatistik;
var i,poz,pomNStatistiky:integer;
    pom1,pom2:string;
begin
 //C*i*t*a*n*i*e subor STATISTIKY
  AssignFile(sStatistiky,'statistiky.txt');
  Reset(sStatistiky);

  Readln(sStatistiky,pom1);             //citanie riadku pocet poloziek
  pomNStatistiky:=strtoint(pom1);

  i:=0;
  While not eof(sStatistiky) do        //citanie poloziek zo suboru do rekordu
  begin
    inc(i);
    Readln(sStatistiky,pom1);
    trim(pom1);

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

    statistiky[i].cenaZaKs:=strtoint(pom1); //citanie udaju Cena za kus

   //******** to do(statistiky[i].IDtransakcie));
  end;
  CloseFile(sStatistiky);

  If pomNStatistiky = i then            //kontrola citania dat
  begin
   NStatistiky:=pomNStatistiky;
  end
  else
   Memo1.Append('problem s nacitanim dat STATISTIKY');
end;

procedure TForm1.Button2Click(Sender: TObject);
var i,j,k,zhoda:integer;
    pomTypObj:string;
begin
 //N*A*K*U*P T*O*V*A*R*U
  pomTypObj:= 'Manualnej objednavky';
  DisplayMessageBox(nObjednavka,pomTypObj);
  If suhlas = true then
  begin
    NStatistiky:=0;
    //If File(sStatistiky) exists then
    CitanieStatistik;

    For i:=1 to nObjednavka do
    begin
    inc(NStatistiky);
    statistiky[NStatistiky].IDtransakcie:='N'+'12345678';
    statistiky[NStatistiky].kod:=objednavka[i].kod;
    statistiky[NStatistiky].ks:=objednavka[i].ks;
    statistiky[NStatistiky].cenaZaKs:=objednavka[i].cenaZaKs;
    end;

    AssignFile(sStatistiky,'statistiky.txt');
    Rewrite(sStatistiky);
    Writeln(sStatistiky,inttostr(NStatistiky));
    For i:=1 to NStatistiky do
      begin
       Writeln(sStatistiky,statistiky[i].IDtransakcie+';'+
       inttostr(statistiky[i].kod)+';'+inttostr(statistiky[i].ks)+';'
       +inttostr(statistiky[i].cenaZaKs));
      end;
    CloseFile(sStatistiky);

    //to do:vyries, ak subor statistiky neexistuje

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
    AssignFile(sSklad1,'sklad.txt');
    Rewrite(sSklad1);
    Writeln(sSklad1,inttostr(nData));
    For i:=1 to nData do
      begin
       Writeln(sSklad1,inttostr(data[i].kod)+';'+inttostr(data[i].ks));
      end;
    CloseFile(sSklad1);


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
      Repeat                           //Kontrola, ci uz vybrany artikel je v Objednavke
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
            +objednavka[nobjednavka].nazov+' ('
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
            StringGrid2.Cells[3,i]:=inttostr(objednavka[i].cenaZaKs);
            StringGrid2.Cells[4,i]:=inttostr(objednavka[i].cenaSpolu);
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

procedure TForm1.Edit1EditingDone(Sender: TObject);
begin

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
  //Cistenie rekord ZOBRAZENE
  nZobrazene:=0;
  For i:=1 to n do
  begin
    zobrazene[i].kod:=0;
    zobrazene[i].nazov:='';
    zobrazene[i].ks:=0;
    zobrazene[i].cenaZaKs:=0;
  end;

  //Vyhodnotenie jednotlivych kategorii
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

  //Zoradenie a vykreslenie StrinGrid1 AKTUALNY stav
  zorad;

end;

end.

//git test
