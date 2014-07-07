//以下の順番でソートすると、「種類/名前」順となる（多分）
sort(1,'text',null);//種類
sort(5,'text',null);//名前

//mouseMove関数があるxmlTable.jsが読み込まれるのはdocument.all.ColumnHeaderAreaのonmousemoveイベントが発生する後なので、ここで別途onmousemoveイベントをアタッチする。
document.all.ColumnHeaderArea.attachEvent("onmousemove", mouseMove); 

