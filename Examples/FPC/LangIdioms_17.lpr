program LangIdioms_17;

(*The structure must be recursive. A node may have zero or more children.
   A node has access to children nodes, but not to his parent.*)

uses
  Classes;

type
generic
  TTree<_T> = class(TObject)
    Children: array of TObject;
    Data: _T;
  end;

type
  TStringTree = specialize TTree<String>;

procedure TreeOutput(const st:TStringTree;PreString:String='');

var
  i: Integer;
begin
  write(prestring);
  writeln('+-',st.Data);
  for i := 0 to high(st.Children) do
    if i = high(st.Children) then
    TreeOutput(TStringTree(st.Children[i]),Prestring+'   ')
    else
      TreeOutput(TStringTree(st.Children[i]),Prestring+'|  ')
end;

var
  Tree: TStringTree;

begin
  Tree := TStringTree.Create;
  with tree do
  begin
    Data := 'Root';
    setlength(Children, 2);
  end;
  tree.Children[0] := TStringTree.Create;
  with TStringTree(tree.Children[0]) do
  begin
    Data := 'Child1';
  end;
  tree.Children[1] := TStringTree.Create;
  with TStringTree(tree.Children[1]) do
  begin
    Data := 'Child2';
  end;

  TreeOutput(Tree);
  readln;
end.
