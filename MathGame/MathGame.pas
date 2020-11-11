program MathGame;
var
  x, y, i, input, cnum, tnum, marks: integer;
begin
 marks:=0;
 write('How many questions? ');
 tnum:=0;
 cnum:=0;
 while tnum<1 do readln(tnum);
 for i:=1 to tnum do
  begin
  randomize;
  x:=random(50)+1;
  y:=random(50)+1;
  write('Q', i, '.', x, '+', y, '=');
  readln(input);
  if x+y=input then
    begin
     writeln('Correct!');
     cnum:=cnum+1;
    end
   else writeln('Incorrect!');
  end;
  marks:=round(cnum/tnum*100);
  writeln('Your mark is: ',marks, '/100!');
  readln
end.

