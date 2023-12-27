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
      margin: 1em 0.5em;
    }
    `;

   
const NonmunContainer = styled.div`
  display:flex;
  flex-direction: column;
  align-items: center;
  text-align:center;
  padding:10px;
`;
const ImageContainer = styled.div`
display:flex;
justify-content: center;
align-items: center;
overflow-x: auto;
margin:10px;
`;
function Nonmun() {
  return (
    <Container>
      <h3>한국정보과학회 KSC 2023</h3>
      <Card>
        <Card.Header as="h2">학부생/주니어 논문경진대회</Card.Header>
        <Card.Body>
            <div>
            <p>10월 30일 한국정보과학회 논문 제출</p>
            <p>12월 21일 KSC 2023 포스터부문 논문 발표</p>
            </div>
            <ImageContainer>
              <img width="40%" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/ksc2023.png?raw=true"/>  
              <img width="40%" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/논문발표.png?raw=true"/>  
            </ImageContainer>
        </Card.Body>
      </Card>
      <Card>
        <Card.Header as="h2">논문 요약</Card.Header>
        <Card.Body>
          <NonmunContainer>
          <h4>스마트기기를 활용한 배드민턴 스윙 분석</h4>
          <p>
            강송모 신도영 임재욱 최지웅 김민호
            <br/>
            {"{ rkdthdah175, ehdud0716, dlawodnr3027, wldnd9904, minhokim } @uos.ac.kr"}
          </p>
          <h4>Badminton Swing Analysis Using Smart Devices</h4>
          <p>
            Songmo Kang, Doyoung Shin, JaeWook Lim, Jiung Choi, Minho Kim
            <br/>
            Department of Computer Science and Engineering, University of Seoul
          </p>
          <p></p>
          <h5>요약</h5>
          <p style={{textAlign:"justify"}}>
            본 연구에서는 스마트 디바이스의 센서를 통해 얻은 가속 및 영상 데이터를 이용해 배드민턴의 가장
            기초적인 스윙인 하이 클리어(High Clear) 스윙을 분석한다. 또한 이를 기반으로 사용자의 레벨을 예측하
            고 스윙의 취약점을 지적해 주는 시스템을 제안한다. 이를 위해 기존에 알려진 실력 요소와 측정 데이터
            를 다양한 방법으로 조합하여 특징 수를 늘리고, 유사도 기법을 활용하여 각 특징이 실력 평가에 영향을
            주는 정도를 파악한다. 11인의 실력 순위 예측 결과, 라켓스포츠 스윙 분석에 주로 사용되는 DTW, MLP
            방법에 비해 MAE는 약 0.25, MSE는 약 2.49만큼 낮게 나온 것을 확인할 수 있다.
          </p>
          </NonmunContainer>
        </Card.Body>
      </Card>
       <Card>
        <Card.Header as="h2">논문 전문</Card.Header>
        <Card.Body>
          <NonmunContainer>
            <caption>추후 논문 업로드 예정</caption>
          </NonmunContainer>
        {/* <embed src="https://raw.githubusercontent.com/wldnd9904/Cokcok/a29fe34b904077faf1afbe8d69d407de7fdb1921/documents/최종%20논문.pdf" width="100%" height="1000px" type="application/pdf"/> */}
        </Card.Body>
      </Card> 
    </Container>
  );
}

export default Nonmun;
