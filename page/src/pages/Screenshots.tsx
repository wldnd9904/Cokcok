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

const swingImages = [
  "스윙분석_페이지",
  "스윙기록_도움말",
  "스윙기록_1",
  "스윙기록_2",
  "스윙기록_3",
  "스윙기록_4",
  "스윙기록_워치_시작전_",
  "스윙기록_워치_기록중_",
  "스윙기록_워치_기록완료_",
  "스윙분석_1",
  "스윙분석_2",
  "스윙분석_3",
];
const swingLabels = [
  "스윙 분석",
  "스윙 분석 도움말",
  "스윙 기록 1",
  "스윙 기록 2",
  "스윙 기록 3",
  "스윙 기록 4",
  "스윙 기록 (watchOS)",
  "스윙 기록 (watchOS) 기록 중",
  "스윙 기록 (watchOS) 기록 종료",
  "분석 결과 1",
  "분석 결과 2",
  "분석 결과 3",
];

const matchImages = [
  "경기기록_메인",
  "경기기록_워치_메트릭_뷰_",
  "경기기록_워치_점수_기록_",
  "경기기록_워치_전송_중_",
  "경기기록_워치_인터넷_연결_없음_",
  "경기기록_워치_결과_요약_",
  "경기기록_1_운동세부사항",
  "경기기록_2_스윙_통계",
  "경기기록_3_스트로크_선택",
];
const matchLabels = [
  "경기 기록",
  "경기 기록 (watchOS) 현재 상태",
  "경기 기록 (watchOS) 점수판",
  "경기 기록 (watchOS) 전송중",
  "경기 기록 (watchOS) 인터넷 연결 없음",
  "경기 기록 (watchOS) 결과 요약",
  "분석 결과 1",
  "분석 결과 2",
  "분석 결과 3",
];

const summaryImages = [
  "메인화면",
  "메인_워치_사용자정보_없음_",
  "메인_워치_사용자정보_받아옴_",
  "요약_페이지",
  "요약_전체_업적",
  "요약_점진적_업적",
  "요약_승률",
  "요약_경기수",
  "요약_스윙수",
  "요약_경기시간",
  "요약_이동거리",
  "요약_마이페이지",
];
const summaryLabels = [
  "메인 화면",
  "watchOS 메인(사용자정보 없음)",
  "watchOS 메인(사용자정보 받아옴)",
  "요약",
  "전체 업적",
  "업적 상세",
  "요약(승률)",
  "요약(경기수)",
  "요약(스윙수)",
  "요약(경기시간)",
  "요약(이동거리)",
  "마이페이지",
];

function Screenshots() {
  return (
    <Container>
      <h3>스크린샷</h3>
      <Card>
        <Card.Header as="h2">메인 및 요약</Card.Header>
        <Card.Body>
          <ImageSlider images={summaryImages.map((name) => { return `https://github.com/wldnd9904/Cokcok/blob/page/page/screenshots/${name}.png?raw=true`; })} labels={summaryLabels} />
        </Card.Body>
      </Card>
      <Card>
        <Card.Header as="h2">스윙 분석</Card.Header>
        <Card.Body>
          <ImageSlider images={swingImages.map((name) => { return `https://github.com/wldnd9904/Cokcok/blob/page/page/screenshots/${name}.png?raw=true`; })} labels={swingLabels} />
        </Card.Body>
      </Card>  
      <Card>
        <Card.Header as="h2">경기 기록</Card.Header>
        <Card.Body>
          <ImageSlider images={matchImages.map((name) => { return `https://github.com/wldnd9904/Cokcok/blob/page/page/screenshots/${name}.png?raw=true`; })} labels={matchLabels} />
        </Card.Body>
      </Card>
    </Container>
  );
}

export default Screenshots;
