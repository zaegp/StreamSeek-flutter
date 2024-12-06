# Flutter Video Source Hunter

Flutter Video Source Hunter 是一個使用 [TMDB API](https://www.themoviedb.org/documentation/api) 的影片與影集搜尋應用程式，讓使用者可以快速查找片源資訊。

## 功能
- 搜尋電影與影集
- 按照精確度排序搜尋結果
- 查看影片詳細資訊（包括評分、簡介、發行日期）
- 提供片源播放資訊（串流平台）

---

## 安裝與運行

### 1. clone 儲存庫
```bash
git clone https://github.com/yourusername/flutter_video_source_hunter.git
cd flutter_video_source_hunter
```

---

### 2. 設置環境變量

本專案使用 `.env` 文件來存放敏感信息（例如 TMDB API 的 Access Token）。在專案根目錄創建 `.env` 文件並按照以下格式填寫：

```plaintext
# .env 文件內容
ACCESS_TOKEN=your_tmdb_access_token_here
```

#### 如何獲取 TMDB Access Token
1. 前往 [TMDB 官網](https://www.themoviedb.org/) 並創建帳戶。
2. 在帳戶設定中，生成 API Access Token。
3. 將獲取的 Access Token 填寫到 `.env` 文件中。

---

### 3. 安裝依賴
運行以下命令安裝 Flutter 項目所需的依賴：
```bash
flutter pub get
```

---

### 4. 運行應用
確保你的設備（模擬器或實體設備）已啟動，然後運行以下命令啟動應用：
```bash
flutter run
```

---

## 常見問題

### 問題：運行應用時提示 "無法獲取詳細資訊"
- **解決方法**：
  - 確保 `.env` 文件存在且填寫了正確的 `TMDB_ACCESS_TOKEN`。
  - 確保已正確安裝應用依賴：
    ```bash
    flutter pub get
    ```
