프로젝트 소개 페이지: https://wldnd9904.github.io/Cokcok/

# 콕콕 - iOS & watchOS App
![COKCOK](https://github.com/wldnd9904/Cokcok/blob/main/page/images/logo_large.png?raw=true)
**콕콕: 배드민턴을 즐기는 사람들을 위한 실력 측정 서비스**
서비스 **콕콕** 은 사용자의 스윙 및 경기 데이터를 분석해 실력 수준을 측정하고, 실력 향상을 위한 정보를 제시합니다. 이를 통해 생활체육으로 배드민턴을 즐기는 이들의 기술 접근성을 높이고, 건강한 체육 활동에 도움이 되고자 합니다.

![iOS](https://github.com/wldnd9904/Cokcok/blob/main/page/images/iOS.png?raw=true)![watchOS](https://github.com/wldnd9904/Cokcok/blob/main/page/images/watchOS.png?raw=true)

# 앱 구조
## iOS
📦cokcok  
 ┣ 📂Extensions  
 ┃ ┣ 📜AVCaptureSession+AddIO.swift  
 ┃ ┣ 📜Color+.swift  
 ┃ ┗ 📜Data+String.swift  
 ┣ 📂Model  
 ┃ ┣ 📜APIAdapater.swift  
 ┃ ┣ 📜APIManager.swift  
 ┃ ┣ 📜Achievement.swift  
 ┃ ┣ 📜AuthenticationManager.swift  
 ┃ ┣ 📜ModelData.swift  
 ┃ ┣ 📜NewUserManager.swift  
 ┃ ┣ 📜SwingAnalyze.swift  
 ┃ ┗ 📜SwingRecordManagerPhone.swift  
 ┣ 📂Shared  
 ┃ ┣ 📜DataManager.swift  
 ┃ ┣ 📜MatchSummary.swift  
 ┃ ┗ 📜User.swift  
 ┣ 📂Utils  
 ┃ ┣ 📜AVAuthorizationChecker.swift  
 ┃ ┣ 📜Date&Time.swift  
 ┃ ┗ 📜VideoError.swift  
 ┣ 📂Views  
 ┃ ┣ 📂Auth  
 ┃ ┃ ┣ 📜LoginView.swift  
 ┃ ┃ ┣ 📜MyPage.swift  
 ┃ ┃ ┣ 📜NewUserView.swift  
 ┃ ┃ ┗ 📜Spinner.swift  
 ┃ ┣ 📂Matches  
 ┃ ┃ ┣ 📜MatchDetail.swift  
 ┃ ┃ ┣ 📜MatchItem.swift  
 ┃ ┃ ┣ 📜Matches.swift  
 ┃ ┃ ┣ 📜ScoreChart.swift  
 ┃ ┃ ┗ 📜StrokeChart.swift  
 ┃ ┣ 📂Summary  
 ┃ ┃ ┣ 📂Achieve  
 ┃ ┃ ┃ ┣ 📜AchievementDetail.swift  
 ┃ ┃ ┃ ┣ 📜AchievementGrid.swift  
 ┃ ┃ ┃ ┣ 📜AchievementItem.swift  
 ┃ ┃ ┃ ┣ 📜AchievementRow.swift  
 ┃ ┃ ┃ ┣ 📜AchievementsView.swift  
 ┃ ┃ ┃ ┗ 📜MedalView.swift  
 ┃ ┃ ┣ 📜RecentMatch.swift  
 ┃ ┃ ┣ 📜RecentSwing.swift  
 ┃ ┃ ┣ 📜Summary.swift  
 ┃ ┃ ┣ 📜SummaryBoxView.swift  
 ┃ ┃ ┣ 📜SummaryCharts.swift  
 ┃ ┃ ┗ 📜SummaryRow.swift  
 ┃ ┗ 📂Swing  
 ┃ ┃ ┣ 📜AVPreview.swift  
 ┃ ┃ ┣ 📜SwingDetail.swift  
 ┃ ┃ ┣ 📜SwingHelpView.swift  
 ┃ ┃ ┣ 📜SwingItem.swift  
 ┃ ┃ ┣ 📜SwingRecordView.swift  
 ┃ ┃ ┣ 📜SwingResultView.swift  
 ┃ ┃ ┣ 📜SwingScoreChart.swift  
 ┃ ┃ ┣ 📜SwingTrendChart.swift  
 ┃ ┃ ┗ 📜SwingView.swift  
 ┣ 📜ContentView.swift  
 ┣ 📜Info.plist  
 ┗ 📜cokcokApp.swift  
 
## watchOS
📦cokcok Watch App  
 ┣ 📂Model  
 ┃ ┣ 📜APIManager.swift  
 ┃ ┣ 📜PathManager.swift  
 ┃ ┣ 📜SwingRecordManagerWatch.swift  
 ┃ ┗ 📜WorkoutManager.swift  
 ┣ 📂Views  
 ┃ ┣ 📂MatchRecord  
 ┃ ┃ ┣ 📜ActivityRingsView.swift  
 ┃ ┃ ┣ 📜ControlsView.swift  
 ┃ ┃ ┣ 📜Counter.swift  
 ┃ ┃ ┣ 📜Counter2.swift  
 ┃ ┃ ┣ 📜ElapsedTimeView.swift  
 ┃ ┃ ┣ 📜MetricsView.swift  
 ┃ ┃ ┣ 📜ScoreView.swift  
 ┃ ┃ ┣ 📜SessionPagingView.swift  
 ┃ ┃ ┗ 📜SummaryView.swift  
 ┃ ┣ 📂SwingRecord  
 ┃ ┃ ┗ 📜SwingRecordWatchView.swift  
 ┃ ┣ 📜CountDownView.swift  
 ┃ ┣ 📜SavedDataView.swift  
 ┃ ┗ 📜StartView.swift  
 ┗ 📜cokcokApp.swift
# 핵심 기능
## 스윙 분석
![스윙분석](https://github.com/wldnd9904/Cokcok/assets/74809873/b621c17b-3466-47d1-a58e-2f731f999309)

**카메라**와 **IMU센서**를 이용하여 사용자의 자세와 손목 움직임을 수집하고, **실력을 평가**합니다.
> **iOS**와 **watchOS**를 연결하고 상태를 관리하기 위해 **WatchConnectivity**를 사용하고, **IMU 센서 데이터**를 수집하기 위해 **CoreMotion**을 사용하였습니다.
## 경기 기록
![경기기록0](https://github.com/wldnd9904/Cokcok/assets/74809873/cc08a58b-b863-43f9-a8a7-4dc83963b8fa)
![경기기록1](https://github.com/wldnd9904/Cokcok/assets/74809873/7ba0d3e6-973a-4da2-abce-87686a48cc5b)
![경기기록2](https://github.com/wldnd9904/Cokcok/assets/74809873/f41b2929-1e82-491d-aad3-a602c23bd432)

**IMU센서를** 이용해 경기를 기록하고, **운동 정보**와 경기 중의 **스윙을 분류 및 분석**합니다.
> **IMU 센서 데이터**를 수집하기 위해 **CoreMotion**을 사용하고, **운동 정보**를 수집하기 위해 **HealthKit**을 사용하였습니다.
## 요약
![요약](https://github.com/wldnd9904/Cokcok/assets/74809873/9918e8d3-a1b7-42c6-b16d-7e3e897446e9)

이번 달의 **배드민턴 통계**를 확인하고, **업적**을 확인할 수 있습니다.
> 전체적인 **레이아웃**은 **SwiftUI**를 이용하여 구현하였고, **그래프**를 표시하기 위해 **Charts**를 사용했습니다.

# 시스템 구조

![시스템 아키텍처](https://github.com/wldnd9904/Cokcok/blob/main/page/images/architecture.png?raw=true)
> **watchOS**와 **iOS**에서 수집한 데이터를 **Amazon EC2 djngo서버**에서 **Python**을 이용해 분석하고, 데이터는 **Amazon RDS** 와 **Amazon S3**에 저장합니다.
## 기술 스택
- 앱: ![](https://img.shields.io/badge/iOS-000000?style=flat&amp;logo=ios&amp;logoColor=white) ![](https://img.shields.io/badge/watchOS-000000?style=flat&amp;logo=ios&amp;logoColor=white) ![](https://img.shields.io/badge/Swift-F05138?style=flat&amp;logo=swift&amp;logoColor=white)
- 서버: ![](https://img.shields.io/badge/django-092E20?style=flat&amp;logo=django&amp;logoColor=white) ![](https://img.shields.io/badge/Amazon%20EC2-FF9900?style=flat&amp;logo=amazon%20ec2&amp;logoColor=white) ![](https://img.shields.io/badge/Amazon%20S3-569A31?style=flat&amp;logo=amazon%20s3&amp;logoColor=white) ![](https://img.shields.io/badge/Amazon%20RDS-527FFF?style=flat&amp;logo=amazon%20rds&amp;logoColor=white)
- 알고리즘: ![](https://img.shields.io/badge/scikitlearn-F7931E?style=flat&amp;logo=scikit-learn&amp;logoColor=white) ![](https://img.shields.io/badge/pandas-150458?style=flat&amp;logo=pandas&amp;logoColor=white) ![](https://img.shields.io/badge/MoveNet-FF6F00?style=flat&amp;logo=tenserflow&amp;logoColor=white)
- 이 레포지토리는 앱 부분만을 포함합니다.
