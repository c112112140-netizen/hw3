# hw3
<img width="2521" height="653" alt="image" src="https://github.com/user-attachments/assets/b61b27da-4b11-4cd1-a1de-7dcf355a32c9" />
hw3是打乒乓球遊戲，用到兩顆按鈕與八顆LED，LED最開始會停在等待右方玩家發球，右方玩家要按下按鈕(sw_r)發球。

遊戲開始後只要左方玩家提早按下按鈕或不按下按鈕都會讓右方玩家得分，得分後LED會顯示雙方的分數後回到獲勝方的發球位置。

狀態機有5種狀態(init,ball_r, ball_l, win_r,win_l,play)。

S0(init)：發球位置，可由雙方玩家決定誰先發球。

S1(ball_r)：LED左移。

S1(ball_l)：LED右移。

S2(win_r)：當左邊玩家提早打或漏接時，右邊玩家得分。

S3(win_l)：當右邊玩家提早打或漏接時，左邊玩家得分。

S4(play)：等待發球狀態，由獲勝方發球。

上板子後，加入除頻來確保led可被肉眼觀察與按鈕加入計數可以防彈跳。

影片連結：https://youtu.be/0Kts5EfaTvo
