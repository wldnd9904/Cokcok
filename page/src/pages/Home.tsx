import React from 'react';
import styled from 'styled-components';
import { Card } from 'react-bootstrap';

const Container = styled.div`
  max-width:700px;
  margin-left:auto;
  margin-right:auto;
  margin-bottom: 10%;
    h2 {
      font-size: 1.5em; /* 폰트 크기 조절, 필요에 따라 조절 가능 */
      font-weight: bold; /* 글꼴 두껍게 설정 */
      color: #333; /* 글꼴 색상 설정, 필요에 따라 조절 가능 */
}
    h3 {
      font-size: 2em; /* 폰트 크기 조절, 필요에 따라 조절 가능 */
      font-weight: bold; /* 글꼴 두껍게 설정 */
      color: #333; /* 글꼴 색상 설정, 필요에 따라 조절 가능 */
      /* 다른 스타일 속성들을 필요에 따라 추가할 수 있습니다. */
      margin: 0.5em;
    }
    >div {
      margin: 1em 0em;
    }
    `;

const Tech = styled.div`
display:flex;
 >img {
  margin:2px;
}
`;
const ImageContainer = styled.div`
display:flex;
justify-content: center;
align-items: center;
margin:10px;
`;
    
function Home() {
  return (
    <Container>
      <h3>콕콕 소개</h3>
      <Card>
        <Card.Header as="h2">콕콕</Card.Header>
        <Card.Body>
          <ImageContainer>
            <img width="200px" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/logo_large.png?raw=true"/>
          </ImageContainer>
          <h5>배드민턴을 즐기는 사람들을 위한 실력 측정 서비스</h5>
          <p>국내에서 배드민턴을 치는 인구는 약 320만명으로, 대표적 생활체육 종목으로 자리잡고 있습니다. 또한 아마추어 선수가 많아 다른 스포츠와 달리 지역 단위의 대회 또한 다수 활성화되어 있습니다. 이처럼 배드민턴은 입문하기 쉽고 대중적이지만, 바른 자세가 중요한 스포츠이기도 합니다. 빠르고 복합적인 움직임을 요구하는 배드민턴 특성 상, 아마추어 수준에서 자신의 자세를 피드백 받을 수 있는 방법은 상급자의 레슨 등으로 한정적입니다. 이러한 방법을 접하지 않은 이들의 잘못된 자세 습관은 부상을 유발하고, 실력 향상에 걸림돌이 됩니다. 전문가 수준에서는 다양한 센서 데이터 수집을 통한 분석이 시도되고 있지만, 이는 추가적인 전문 장비를 요구하기 때문에 아마추어 수준에서 기술 접근성이 떨어집니다.</p>  
          <p>서비스 ‘콕콕’은 사용자의 스윙 및 경기 데이터를 분석해 실력 수준을 측정하고, 실력 향상을 위한 정보를 제시합니다. 이를 통해 생활체육으로 배드민턴을 즐기는 이들의 기술 접근성을 높이고, 건강한 체육 활동에 도움이 되고자 합니다.</p>
          <ImageContainer>
          <img width="30%" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/iOS.png?raw=true"/>
          <img width="30%" height="30%" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/watchOS.png?raw=true"/>  
          </ImageContainer>
        </Card.Body>
      </Card>
      <Card>
        <Card.Header as="h2">핵심 기능</Card.Header>
        <Card.Body>
          <h5>스윙 분석</h5>
          <p>카메라와 IMU센서를 이용하여 사용자의 자세와 손목 움직임을 수집하고, 분석합니다.</p>
          <ImageContainer>
            <img width="200px" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/스윙기록_3.png?raw=true"/>
            <img width="200px" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/스윙분석_2.png?raw=true"/>
          </ImageContainer>

          <h5>경기 기록</h5>
          <p>IMU센서를 이용해 경기를 기록하고, 운동 정보와 경기 중의 스윙들을 분석합니다.</p>
          <ImageContainer>
            <img width="150px" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/경기기록_워치_결과_요약_.png?raw=true"/>  
            <img width="200px" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/경기기록_1_운동세부사항.png?raw=true"/>
            <img width="200px" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/경기기록_3_스트로크_선택.png?raw=true"/>
          </ImageContainer>
          
          <h5>요약</h5>
          <p>이번 달의 배드민턴 통계를 확인하고, 업적을 확인할 수 있습니다.</p>
          <ImageContainer>
            <img width="200px" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/요약_페이지.png?raw=true"/>
            <img width="200px" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/요약_전체_업적.png?raw=true"/>
          </ImageContainer>

        </Card.Body>
      </Card>
      <Card>
        <Card.Header as="h2">아키텍처</Card.Header>
        <Card.Body>
          <ImageContainer>
            <img width="100%" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/architecture.png?raw=true"/>
          </ImageContainer>
        </Card.Body>
      </Card>
      <Card>
        <Card.Header as="h2">기술 스택</Card.Header>
        <Card.Body>
          <Tech>
            앱:
          <img src="https://img.shields.io/badge/iOS-000000?style=flat&logo=ios&logoColor=white"/>
          <img src="https://img.shields.io/badge/watchOS-000000?style=flat&logo=ios&logoColor=white"/>
          <img src="https://img.shields.io/badge/Swift-F05138?style=flat&logo=swift&logoColor=white"/>
          </Tech>
          <Tech>
            서버:
            <img src="https://img.shields.io/badge/django-092E20?style=flat&logo=django&logoColor=white"/>
            <img src="https://img.shields.io/badge/Amazon%20EC2-FF9900?style=flat&logo=amazon%20ec2&logoColor=white"/> 
            <img src="https://img.shields.io/badge/Amazon%20S3-569A31?style=flat&logo=amazon%20s3&logoColor=white"/> 
            <img src="https://img.shields.io/badge/Amazon%20RDS-527FFF?style=flat&logo=amazon%20rds&logoColor=white"/> 
          </Tech>
          <Tech>
            알고리즘:
          <img src="https://img.shields.io/badge/scikitlearn-F7931E?style=flat&logo=scikit-learn&logoColor=white"/>
          <img src="https://img.shields.io/badge/pandas-150458?style=flat&logo=pandas&logoColor=white"/>
          <img src="https://img.shields.io/badge/MoveNet-FF6F00?style=flat&logo=tenserflow&logoColor=white"/>
          </Tech>
        </Card.Body>
      </Card>
    </Container>
  );
}

export default Home;
