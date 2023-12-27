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

const KscContainer = styled.div`
  display:flex;
  justify-content: space-between;
`;
    
function Nonmun() {
  return (
    <Container>
      <h3>한국정보과학회 KSC 2023</h3>
      <Card>
        <Card.Header as="h2">학부생/주니어 논문경진대회</Card.Header>
        <Card.Body>
          <KscContainer>
            <div>
            <p>10월 30일 한국정보과학회 논문 제출</p>
            <p>12월 21일 KSC 2023 포스터부문 논문 발표</p>
            </div>
            <img width="50%" src="https://github.com/wldnd9904/Cokcok/blob/page/page/images/ksc2023.png?raw=true"/>  
          </KscContainer>
        </Card.Body>
      </Card>

      <Card>
        <Card.Header as="h2">논문 전문</Card.Header>
        <Card.Body>
        <embed src="https://raw.githubusercontent.com/wldnd9904/Cokcok/a29fe34b904077faf1afbe8d69d407de7fdb1921/documents/최종%20논문.pdf" width="100%" height="1000px" type="application/pdf"/>
        </Card.Body>
      </Card>
    </Container>
  );
}

export default Nonmun;
