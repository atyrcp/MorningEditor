# 早安圖編輯器（MorningEditor）

簡單編輯出自己的早安貼圖

如有相關問題，亦歡迎透過 email 聯絡：atyrcp＠gmail.com

***

## App架構：
所有元件統一將 Viewcontroller 設為 Delegate 對象，Viewcontroller 再將接收到的事件分派給 EditEventHandler 物件處理
* 若為 TextableLabelView 物件，表示其為使用者正在編輯的文字方框，則設定其為更改顏色、大小的目標
* 若為特定 Buttons，則傳送該 Button 的資訊，並決定對象 TextableLabelView 應該更改的屬性

<img src = "App Overview.001.jpeg">

## 元件繼承關係與位置：
主要元件的繼承關係與其在 App 中的位置
* 粉紅色的 MainButton 系列因線條混亂，便不逐一指出其在 App 中的位置
* 只有單一數量的元件如 Slider 也不再另外畫線條指示位置

<img src = "App Overview.002.jpeg">

## Protocol概述：
App 中的核心 Protocol 資訊
* 功能較簡單易懂的 Pannable, Pinchable 表格中未列出

<img src = "App Overview.003.jpeg">
