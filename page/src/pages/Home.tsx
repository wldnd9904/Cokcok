import React from 'react';
import ImageSlider from '../components/ImageSlider';
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
    
function Home() {
  return (
    <Container>
      <h3>콕콕 소개</h3>
      <Card>
        <Card.Header as="h2">제목</Card.Header>
        <Card.Body>
          <p>내용</p>
        </Card.Body>
      </Card>
      <Card>
        <Card.Header as="h2">제목</Card.Header>
        <Card.Body>
          <p>내용</p>
        </Card.Body>
      </Card>
      <Card>
        <Card.Header as="h2">제목</Card.Header>
        <Card.Body>
          <p>어쩌고저쩌고</p>
        </Card.Body>
      </Card>
</Container>
  );
}

export default Home;
