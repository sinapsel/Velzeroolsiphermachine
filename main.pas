{----------------------------------------------------------------------------------------------------------------------------------------}
type
  SHelp = class
  public 
    procedure DrawEnter();
    begin
      writeln('***************************************************************');
      writeln('*    Project: VelzeroolSipherMachine  by aka sinapsel         *');
      writeln('*    Version: 2.0.1                                           *');
      writeln('*    Description: Enrypts and decrypts chars with the keyword *');
      writeln('*                 with 5 different algoritms                  *');
      writeln('*    Development started from: 17 feb 2017                    *');
      writeln('*    License:  GNU General Public License v3.0                *');
      writeln('***************************************************************');
    end;
    
    procedure DrawLN(n: integer);
    begin
      for var i := 1 to n do writeln();
    end;
    
    procedure GetSTR(var str: string);
    begin
      write('STRING:   ');
      readln(str);
    end;
    
    procedure GetKEY(var str: string);
    begin
      write('KEY:      ');
      readln(str);
    end;
    
    procedure AskOnStartNOPARAMS(var choise: char);
    begin
      write('Print 1 to encrypt, 2 to decrypt, e to exit:   ');
      readln(choise);
      while ((choise <> '1') and (choise <> '2') and (choise <> 'e')) do
      begin
        writeln('Incorrect format, try again!');
        readln(choise);
      end;
    end;
  end;

{----------------------------------------------------------------------------------------------------------------------------------------}


{----------------------------------------------------------------------------------------------------------------------------------------}
type
  SipherVelz = class
  private 
    movCoef: integer := 128{3245};
    Codes64 := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    function dec2bin(x: integer): string;
    var
      s: string;
    begin
      s := '';
      while x > 0 do
      begin
        s := chr(ord('0') + x mod 2) + s;
        x := x div 2;
      end;
      dec2bin := s;
    end;
    
    function va(a: string): integer;
    var
      bs, er: integer;
    begin
      val(a, bs, er);
      va := bs;
    end;
  
  public 
    TextIN, key, TextOut: string;
    
    procedure cutng(ins, key: string; var cuts: string);
    var
      oldL, e: integer;
    begin//обрезка ключа
      e := 1;
      oldL := length(key);
      for var i := 1 to length(ins) do 
      begin
        cuts += key[e];
        if(e = oldL) then e := 1 else e += 1;
      end;
    end;
    
    function XCiph(ins, key: string): string;
    var
      tS: string;
    begin
      for var i := 1 to ins.Length do tS += chr(ord(ins[i]) xor ord(key[i]));
      XCiph := ts;
    end;
    
    
    function ENBASE2_6(S: string): string;
    var
      i, a, x, b: Integer;
    begin
      for i := 1 to Length(s) do
      begin
        x := Ord(s[i]);
        b := b * (movCoef * 2) + x;
        a := a + 8;
        while a >= 6 do
        begin
          a := a - 6;
          x := b div (1 shl a);
          b := b mod (1 shl a);
          Result := Result + Codes64[x + 1];
        end;
      end;
      if a > 0 then
      begin
        x := b shl (6 - a);
        Result := Result + Codes64[x + 1];
      end;
    end;
    
    function OUTBASE2_6(S: string): string;
    var
      i, a, x, b: Integer;
    begin
      for i := 1 to Length(s) do
      begin
        x := Pos(s[i], codes64) - 1;
        if x >= 0 then
        begin
          b := b * 64 + x;
          a := a + 6;
          if a >= 8 then
          begin
            a := a - 8;
            x := b shr a;
            b := b mod (1 shl a);
            x := x mod (movCoef * 2);
            Result := Result + chr(x);
          end;
        end
        else
          exit;
      end;
    end;
    
    
    
    function AlefTetBetShin(ins: string): string;
    var
      i: integer;
    begin
      for i := 1 to length(ins) do
        ins[ i ] := Chr(movCoef * 2 - Ord(ins[ i ]));
      AlefTetBetShin := ins;
    end;
    
    
    
    
    function CaeserInTOthefuture(ins: string): string;
    begin
      for var i := 1 to length(ins) do ins[i] := chr(ord(ins[i]) + movCoef);
      Result := ins;
    end;
    
    function CaeserBackTOthefuture(ins: string): string;
    begin
      for var i := 1 to length(ins) do ins[i] := chr(ord(ins[i]) - movCoef);
      Result := ins;
    end;
    
    
    
    function Incode(ins, key: string): string;
    var
      a: string;
    begin
      a := ins;
      
      a := AlefTetBetShin(a);
      a := XCiph(a, key);
      a := CaeserInTOthefuture(a);
      a := ENBASE2_6(a);
      // a := BaseIn(a);
      
      Result := a;
    end;
    
    function Decode(ins, key: string): string;
    var
      a: string;
    begin
      a := ins;
      
      // a := BaseOut(a);
      a := OUTBASE2_6(a);
      a := CaeserBackTOthefuture(a);
      a := XCiph(a, key);
      a := AlefTetBetShin(a);
      
      Result := a;
    end;
  
  end;
{----------------------------------------------------------------------------------------------------------------------------------------}


procedure GenKey(var key1: string);
var
  i: integer;
begin
  for i := 1 to 8 do key1:= key1 + Chr(Random(30, 128));
end;


var
  helpvar: SHelp;
  siph1: SipherVelz;
  ch: char;
  instr, key, outstr: string;

begin
  Randomize;
  helpvar := SHelp.Create(); //Help init
  helpvar.DrawEnter();
  helpvar.DrawLN(2);
  siph1 := SipherVelz.Create();//Sipher class init
  if (ParamCount = 0) then  begin//if no params
    helpvar.AskOnStartNOPARAMS(ch);
    if(ch = 'e') then Halt(1);
    helpvar.GetSTR(instr); 
    helpvar.GetKEY(key);
  end //ключ
  else if(ParamCount = 3) then begin//2 params: string and key 
    ch := ParamStr(1)[1];               {file siphering will be aviable soon!!!!!!!}
    instr := ParamStr(2); end;
  
  siph1.TextIN := instr;
  if(Length(key) >= 4) then
    siph1.key := key else begin GenKey(key); siph1.key := key; writeln('NEW KEY:  ',key); end;
  
  siph1.cutng(siph1.TextIN, siph1.key, siph1.key);//calirating key to string size
  case (ch) of
    '1': begin outstr := (siph1.Incode(siph1.TextIN, siph1.key));  end;
    '2': begin outstr := (siph1.Decode(siph1.TextIN, siph1.key));  end;
    'e': Halt();
  end;
  writeln('RESULT:   ',outstr); //OUTPUT
  
end.
