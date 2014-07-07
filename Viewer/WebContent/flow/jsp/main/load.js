sort(1,'number',null);//IDでソート

//mouseMove関数があるxmlTable.jsが読み込まれるのはdocument.all.ColumnHeaderAreaのonmousemoveイベントが発生する後なので、ここで別途onmousemoveイベントをアタッチする。
document.all.ColumnHeaderArea.attachEvent("onmousemove", mouseMove); 
