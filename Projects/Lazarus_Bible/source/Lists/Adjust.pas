var
  I, J, K: Integer;
begin
  with ListBox1 do
  begin
    K := 0;
    for I := 0 to Items.Count Ð 1 do
    begin
      J := Canvas.TextWidth(Items[I]);
      if J > K then K := J;
    end;
    Perform(LB_SETHORIZONTALEXTENT, K, 0);
  end;
end;
