unit UnitCL3D26Project;

{$mode objfpc}{$H+}{$M+}
{$modeSwitch AdvancedRecords}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, LCLType, Menus, ActnList, EditBtn, Interfaces;

//File Names
const
  CLicensingFileName='LICENSE.txt';
type

  { TForm1 }

  //a bunch of form stuff, automatically made
  TForm1 = class(TForm)
    ActionSave: TAction;
    ActionOpen: TAction;
    ActionList: TActionList;
    LabelTitle: TLabel;
    LabelTime: TLabel;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    MenuFontLarge: TMenuItem;
    MenuHelpInfo: TMenuItem;
    MenuFontSize: TMenuItem;
    MenuFontSmall: TMenuItem;
    MenuFontMedium: TMenuItem;
    MenuOptions: TMenuItem;
    MenuLicense: TMenuItem;
    MenuNewFile: TMenuItem;
    MenuNewItem: TMenuItem;
    MenuNew: TMenuItem;
    MenuOpen: TMenuItem;
    MenuSave: TMenuItem;
    MenuQuit: TMenuItem;
    MenuHelp: TMenuItem;
    OpenFile: TOpenDialog;
    Panel1: TPanel;
    SaveFile: TSaveDialog;
    ScrollBar1: TScrollBar;
    procedure ActionOpenExecute(Sender: TObject);
    procedure ActionQuitExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MenuFontLargeClick(Sender: TObject);
    procedure MenuFontMediumClick(Sender: TObject);
    procedure MenuFontSmallClick(Sender: TObject);
    procedure MenuHelpInfoClick(Sender: TObject);
    procedure MenuLicenseClick(Sender: TObject);
    procedure MenuNewFileClick(Sender: TObject);
    procedure MenuNewItemClick(Sender: TObject);
    procedure MenuQuitClick(Sender: TObject);
    procedure MenuSaveClick(Sender: TObject);
    procedure ButtonCreating;
    procedure ScrollBar1Change(Sender: TObject);
  private
  procedure TheButtonClick(Sender: TObject);
  public

  end;

var
  //Variable declarations, previous full of stuff for autosizing but ditched in favour of the new infinite display size system.
  Form1: TForm1;
  FormHeightRatio, FormWidthRatio, ButtonPageChangeRatio:real;
  BoxStyle, FormHeight, FormWidth, LabelTitleHeight, FormDefaultHeight, FormDefaultWidth, LabelTitleFontSize, FileLineNumber, ButtonFontSize, LabelFontSize, NumOfItems:integer;
  filename, TestCaption, FormHeightString, FileText, ErrorReport: string;
  //File Handling stuff
  TempFileOutput, FileInput:TextFile;
  EventNameArray: array [1..32768] of string;
  EventDescArray: array [1..32768] of string;
  EventYearArray: array [1..32768] of string;
  EventMonthArray: array [1..32768] of string;
  EventDayArray: array [1..32768] of string;
  EventDateArray: array [1..32768] of integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
    //Dialog to ask for opening a save
    if MessageDlg('Load save?', 'Welcome to Undone! Do you wish to load up a previously saved Undone todolist file? Choose No if you want to create a new file. You can choose to load the save later.', mtConfirmation,[mbYes, mbNo, mbIgnore],0) = mrYes
      then ActionOpen.Execute;
    Form1.LabelTime.Caption:=DateToStr(Date);
end;
procedure TForm1.MenuFontLargeClick(Sender: TObject);
begin
  LabelTitleFontSize:=48;
  ButtonFontSize:=16;
  LabelFontSize:=14;
  Form1.LabelTitle.Font.Size:=LabelTitleFontSize;
  Form1.LabelTime.Font.Size:=Form1.LabelTitle.Font.Size;
end;

procedure TForm1.MenuFontMediumClick(Sender: TObject);
begin
  LabelTitleFontSize:=40;
  ButtonFontSize:=14;
  LabelFontSize:=12;
  Form1.LabelTitle.Font.Size:=LabelTitleFontSize;
  Form1.LabelTime.Font.Size:=Form1.LabelTitle.Font.Size;
end;

procedure TForm1.MenuFontSmallClick(Sender: TObject);
begin
  LabelTitleFontSize:=36;
  ButtonFontSize:=12;
  LabelFontSize:=10;
  Form1.LabelTitle.Font.Size:=LabelTitleFontSize;
  Form1.LabelTime.Font.Size:=Form1.LabelTitle.Font.Size;
end;

procedure TForm1.MenuHelpInfoClick(Sender: TObject);
begin
  //Help dialog, includes Undone help and information
  MessageDlg('Undone Help and Information', 'Welcome to Undone!'+sLineBreak+''+sLineBreak+'Undone is a todo list program that allow you to organize and manage your undone matters!'+sLineBreak+''+sLineBreak+'Use the "New File" button under "New" in "File", or press the F1 key to make a new file, press the "Open" button under "File" or press Control+O to load a previously saved Undone file, press the "Save" button, also under "File",or use the shortcut Control+S to save the current todo list, use the "Help and info" option under "Help" or use Control+H to show this information, press to create a new item!', mtInformation, [mbOK], 0);
end;
procedure TForm1.MenuLicenseClick(Sender: TObject);
begin
  //Dialog for licensing informations.
  MessageDlg('Licensing information', 'Copyright 2020 Carson Cheung(Planeson P.)'+sLineBreak+''+sLineBreak+'Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:'+sLineBreak+''+sLineBreak+'The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.'+sLineBreak+''+sLineBreak+'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.', mtInformation, [mbOK], 0);
end;

procedure TForm1.MenuNewFileClick(Sender: TObject);
var
  ClearLoopNum:integer;
begin
  for ClearLoopNum:=((NumOfItems*3)) downto 0 do Panel1.Components[ClearLoopNum].Free;
  for ClearLoopNum:=NumOfItems downto 1 do
  begin
    EventNameArray[ClearLoopNum]:='';
    EventDescArray[ClearLoopNum]:='';
    EventYearArray[ClearLoopNum]:='';
    EventMonthArray[ClearLoopNum]:='';
    EventDayArray[ClearLoopNum]:='';
  end;
 NumOfItems:=0
end;
procedure TForm1.MenuNewItemClick(Sender: TObject);
var
  NewIndex: integer;
  Input : string;
begin
  NewIndex:=NumOfItems+1;
  Input:='';
  Repeat
    InputQuery('Name of the new item', 'Please input the name of the new item', Input);
  until Input<>'';
  EventNameArray[NewIndex]:=Input;
  Input:='';
  Repeat
    InputQuery('Description of the new item', 'Please input the description of the new item', Input);
  until Input<>'';;
  EventDescArray[NewIndex]:=Input;
  Input:='';
  Repeat
    InputQuery('Year of the new item', 'Please input the year of the new item', Input);
  until Input<>'';
  EventYearArray[NewIndex]:=Input;
  Input:='';
  Repeat
    InputQuery('Month of the new item', 'Please input the month of the new item', Input);
  until Input<>'';
  EventMonthArray[NewIndex]:=Input;
  Input:='';
  Repeat
    InputQuery('Day of the new item', 'Please input the day of the new item', Input);
  until Input<>'';
  EventDayArray[NewIndex]:=Input;
  Input:='';
  NumOfItems:=NumOfItems+1;
  ButtonCreating;
end;
procedure TForm1.MenuQuitClick(Sender: TObject);
var
  ButtonChoice:integer;
begin
    //Prompt user to save before quitting.
    ButtonChoice:=MessageDlg('Save the current file?', 'Before you leave, do you want to save the current file? If you do not save now, your current file cannot be used later! Press "Cancel" to cancel the termination of the program and continue managing your undone list.', mtConfirmation,[mbYes, mbNo, mbCancel],0);
    //Save the file if yes, then kill the program with Halt.
    if ButtonChoice=mrYes
    then
      begin
        ActionSave.Execute;
        Halt;
      end
    //If no, kill the program with Halt.
    else if ButtonChoice=mrNo
    then Halt;
end;

procedure TForm1.MenuSaveClick(Sender: TObject);
begin
  ActionSave.execute;
end;
procedure TForm1.ButtonCreating;
  var
   //loopnumber is to loop, the button is the dynamically generated button
    LoopNumber: integer;
    TheButton: TButton;
    LabelDate, LabelDesc: TLabel;
    begin
    for LoopNumber:=1 to NumOfItems do
    begin
      //BUTTON create and set the properties
      TheButton:=TButton.Create(Form1.Panel1);
      TheButton.Parent:=Form1.Panel1;
      TheButton.Caption:=EventNameArray[LoopNumber];
      TheButton.Font.Size:=30;
      TheButton.OnClick:=@TheButtonClick;
      TheButton.Anchors:=[akTop, akLeft, akRight];
      TheButton.AnchorSide[akTop].Control:=Form1.Panel1;
      TheButton.BorderSpacing.Top:=120*(LoopNumber-1);
      TheButton.AnchorSide[akTop].Side:=asrTop;
      TheButton.AnchorSide[akRight].Control:=Form1.Panel1;
      TheButton.AnchorSide[akRight].Side:=asrRight;
      TheButton.AnchorSide[akLeft].Control:=Form1.Panel1;
      TheButton.AnchorSide[akLeft].Side:=asrLeft;
      //seting min height as a way to identify the button clicked easily
      TheButton.Tag:=LoopNumber;
      TheButton.Constraints.MinHeight:=60;


      //DATE create and properties
      LabelDate:=TLabel.Create(Form1.Panel1);
      LabelDate.Parent:=Form1.Panel1;
      LabelDate.Caption:=EventYearArray[LoopNumber]+'/'+EventMonthArray[LoopNumber]+'/'+EventDayArray[LoopNumber];
      LabelDate.Font.Size:=13;
      LabelDate.Anchors:=[akTop, akLeft, akRight];
      LabelDate.AnchorSide[akTop].Control:=Form1.Panel1;
      LabelDate.BorderSpacing.Top:=(120*(LoopNumber-1)+60);
      LabelDate.AnchorSide[akTop].Side:=asrTop;
      LabelDate.AnchorSide[akRight].Control:=Form1.Panel1;
      LabelDate.AnchorSide[akRight].Side:=asrRight;
      LabelDate.AnchorSide[akLeft].Control:=Form1.Panel1;
      LabelDate.AnchorSide[akLeft].Side:=asrLeft;


      //DESC create and properties
      LabelDesc:=TLabel.Create(Form1.Panel1);
      LabelDesc.Parent:=Form1.Panel1;
      LabelDesc.Caption:=EventDescArray[LoopNumber];
      LabelDesc.Font.Size:=13;
      LabelDesc.Anchors:=[akTop, akLeft, akRight];
      LabelDesc.AnchorSide[akTop].Control:=Form1.Panel1;
      LabelDesc.BorderSpacing.Top:=(120*(LoopNumber-1)+90);
      LabelDesc.AnchorSide[akTop].Side:=asrTop;
      LabelDesc.AnchorSide[akRight].Control:=Form1.Panel1;
      LabelDesc.AnchorSide[akRight].Side:=asrRight;
      LabelDesc.AnchorSide[akLeft].Control:=Form1.Panel1;
      LabelDesc.AnchorSide[akLeft].Side:=asrLeft;
    end;
  end;
procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  Panel1.Top:=ScrollBar1.Position+170;
end;

procedure TForm1.TheButtonClick(Sender: TObject);
var
  ResetPanelNum, ButtonNumber: integer;
  Input:string;
begin
  if messageDlg('Edit?', ' Press ok to edit this event, or cancel to cancel this action.', mtConfirmation, [mbOK, mbCancel], 0)=mrOK
  then
   begin
  ButtonNumber:=TButton(Sender).Tag;
  Input:='';
  Repeat
    InputQuery('Name of the new item', 'Please input the name of the new item', Input);
  until Input<>'';
  EventNameArray[ButtonNumber]:=Input;
  Input:='';
  Repeat
    InputQuery('Description of the new item', 'Please input the description of the new item', Input);
  until Input<>'';;
  EventDescArray[ButtonNumber]:=Input;
  Input:='';
  Repeat
    InputQuery('Year of the new item', 'Please input the year of the new item', Input);
  until Input<>'';
  EventYearArray[ButtonNumber]:=Input;
  Input:='';
  Repeat
    InputQuery('Month of the new item', 'Please input the month of the new item', Input);
  until Input<>'';
  EventMonthArray[ButtonNumber]:=Input;
  Input:='';
  Repeat
    InputQuery('Day of the new item', 'Please input the day of the new item', Input);
  until Input<>'';
  EventDayArray[ButtonNumber]:=Input;
  Input:='';
  for ResetPanelNum:=((NumOfItems*3)-1) downto 0 do Panel1.Components[ResetPanelNum].Free;
  ButtonCreating;
  //repeat to fix a bug quickly, it's now 10 minutes from deadline, don't ask me how it works, I just found this out by mistake
  for ResetPanelNum:=((NumOfItems*3)-1) downto 0 do Panel1.Components[ResetPanelNum].Free;
  ButtonCreating;
   end;
end;

procedure TForm1.FormChangeBounds(Sender: TObject);
//Auto-scaling, note that with the change in the layout, this part became mostly obsolete.
begin
  //Using the form height as a scaler
  FormHeight:=Form1.height-20;
  //20 is the height of MainMenu
  FormWidth:=Form1.width;
  //Ratio to use everything autosized
  FormHeightRatio:=(FormHeight/FormDefaultHeight);
  FormWidthRatio:=(FormWidth/FormDefaultWidth);
  //Real size changing part part
  LabelTitle.Height:=round(FormHeightRatio*LabelTitleHeight);
  LabelTime.Height:=LabelTitle.Height;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  ButtonChoice: integer;
begin
  //Prompt user to save before quitting.
    ButtonChoice:=MessageDlg('Save the current file?', 'Before you leave, do you want to save the current file? If you do not save now, your current file cannot be used later! Press "Cancel" to cancel the termination of the program and continue managing your undone list.', mtConfirmation,[mbYes, mbNo, mbCancel],0);
    //Save the file if yes, then kill the program with Halt.
    if ButtonChoice=mrYes
    then
      begin
        ActionSave.Execute;
        Halt
      end
    //If no, kill the program with Halt.
    else if ButtonChoice=mrNo
    then Halt
    else CloseAction:=caNone;
end;
procedure TForm1.ActionQuitExecute(Sender: TObject);
var
  ButtonChoice: integer;
begin //Prompt user to save before quitting.
    ButtonChoice:=MessageDlg('Save the current file?', 'Before you leave, do you want to save the current file? If you do not save now, your current file cannot be used later! Important note: due to coding limitations, if you closed the program from the top right, the closing cannot be cancelled.', mtConfirmation,[mbYes, mbNo, mbCancel],0);
    if ButtonChoice=mrYes
    then
      begin
         //Calling ActionSave to save
         ActionSave.Execute;
      Halt
      end
    else if ButtonChoice=mrNo
    then Halt
    else
end;

procedure TForm1.ActionSaveExecute(Sender: TObject);
var
  WriteLoopNum:integer;
  ErrorReport:string;
begin
  //Calling File saving dialog
  if SaveFile.execute then
    begin
      AssignFile(TempFileOutput, SaveFile.FileName);
        //Error-catching exception
        {$I+}
        //Embed the file creation in a try/except block to handle errors more "peacefully"
        try
        //Create the file, write the list and close it.
        rewrite(TempFileOutput);
        for WriteLoopNum:=1 to NumOfItems do
        begin
          writeln(TempFileOutput, EventNameArray[WriteLoopNum]);
          writeln(TempFileOutput, EventDescArray[WriteLoopNum]);
          writeln(TempFileOutput, EventYearArray[WriteLoopNum]);
          writeln(TempFileOutput, EventMonthArray[WriteLoopNum]);
          writeln(TempFileOutput, EventDayArray[WriteLoopNum]);
        end;
        CloseFile(TempFileOutput);
        ShowMessage('File written successfully!');
        except
        //Error reporting for the file
        on E: EInOutError do
        begin
          ErrorReport:='File was unable to be saved. Details: '+E.ClassName+'/'+E.Message+'. Report this bug to me at Planeson115@gmail.com or cpkplkcy@gmail.com to get it fixed!';
          MessageDlg('Undone File Reading Error', ErrorReport, mtError, [mbOK], 0);
        end;
     end;
  end;
end;

procedure TForm1.ActionOpenExecute(Sender: TObject);
var
 ItemType: integer;
 ErrorReport, Year, Month, Date: String;
  begin
  //OpenFile is the OpenDialog, OpenFile.execute calls the OpenDialog
  if OpenFile.execute
  then
    begin
       try
       //assign the file
       {$I-}
       assignfile(FileInput, OpenFile.FileName);
       reset(FileInput);
       {$I+}
       //eof is checking for the end of the file.
       //Loop to read the files to store into the computer's Random Access Memory. Reading from the file directly will be inconvienent for the user.
       while not eof(FileInput) do
       begin
       NumOfItems:=NumOfItems+1;
       ItemType:=1;
         repeat
           readln(FileInput, FileText);
            if ItemType=6
             then
              begin
               NumOfItems:=NumOfItems+1;
               ItemType:=1;
              end;
              if ItemType=1 then EventNameArray[NumOfItems]:=FileText
               else if ItemType=2 then EventDescArray[NumOfItems]:=FileText
               else if ItemType=3
               then
                begin
                  EventYearArray[NumOfItems]:=FileText;
                  Year:=(FileText);
                end
               else if ItemType=4
               then
                begin
                  EventMonthArray[NumOfItems]:=FileText;
                  Month:=(FileText);
                end
               else if ItemType=5
               then
                begin
                  EventDayArray[NumOfItems]:=FileText;
                  Date:=Year+Month+FileText;
                  EventDateArray[NumOfItems]:=StrToInt(Date);
                end;
               ItemType:=ItemType+1;
             until eoln (FileInput);
         ButtonCreating;
         CloseFile(FileInput);
       end;
       except
       on E: EInOutError do
        begin
          ErrorReport:='File was unable to be opened. Details: '+E.ClassName+'/'+E.Message+'. Check your file for corruption or incorrect modifications. IMPORTANT NOTE: even if an exception is shown after opening a file, continue. I am not sure on why that happens, it only started after I finished writing the file saving part of the program.';
          MessageDlg('Undone File Reading Error', ErrorReport, mtError, [mbOK], 0);
        end;
    end
 end;
end;

begin
  Application.Scaled:=True;
 //Height (ratio) reference, change for different ratio
 FormDefaultHeight:=750;
 FormDefaultWidth:=500;
 LabelTitleHeight:=85;
 NumOfItems:=0;
 ShowMessage('IMPORTANT NOTE: even if an exception is shown after opening a file, continue. I am not sure on why that happens, it only started after I finished writing the file saving part of the program.');
 ShowMessage('Please place this executable in a folder where you can access, preferably without needing administative rights. If you decide to put this executable in a place where you need administative rights, please run this executable using the "Run as Administrator" option.');
 //set the name of the file that will be created
 AssignFile(TempFileOutput, CLicensingFileName);
 //error-catching exception
 {$I+}
 //embed the file creation in a try/except block to handle errors "peacefully"
 try
   //creating the file
   rewrite(TempFileOutput);
   //writing the license
   writeln(TempFileOutput, 'Copyright 2020 Carson Cheung(Planeson P.)');
   writeln(TempFileOutput, '');
   writeln(TempFileOutput, 'Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated');
   writeln(TempFileOutput, 'documentation files (the "Software"), to deal in the Software without restriction, including without limitation');
   writeln(TempFileOutput, 'the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and');
   writeln(TempFileOutput, 'to permit persons to whom the Software is furnished to do so, subject to the following conditions:');
   writeln(TempFileOutput, '');
   writeln(TempFileOutput, 'The above copyright notice and this permission notice shall be included in all copies or substantial portions of');
   writeln(TempFileOutput, 'the Software.');
   writeln(TempFileOutput, '');
   writeln(TempFileOutput, 'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO');
   writeln(TempFileOutput, 'THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE');
   writeln(TempFileOutput, 'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF');
   writeln(TempFileOutput, 'CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER');
   write(TempFileOutput, 'DEALINGS IN THE SOFTWARE.');
   //close to file to free up the memory used
   CloseFile(TempFileOutput);
 except
   //error reporting for the LICENSE.txt file
   on E: EInOutError do
     begin
       ErrorReport:=('File handling error occurred. Undone is forced to quit. Details: '+E.ClassName+'/'+E.Message+' you should try launch this app as an administrator or put it somewhere like the desktop where you do not need permission to run this application executable.');
       MessageDlg('Undone File Writing Error', ErrorReport, mtError, [mbOK], 0);
     end;
 end;
end.
