import React, { useEffect, useState } from 'react';
import ImageSlider from '../components/ImageSlider';
import styled from 'styled-components';
import ReactMarkdown from 'react-markdown';
import { Card } from 'react-bootstrap';

const Container = styled.div`
  max-width:700px;
  margin-left:auto;
  margin-right:auto;
  margin-bottom: 10%;
    `;

const Title = styled.div`
  margin:10px;
`

interface MarkdownPageParams {
  filePath:string
  title:string
}

function MarkdownPage(params:MarkdownPageParams) {
  const [markdownContent, setMarkdownContent] = useState('');

  useEffect(() => {
    // 여기서 mdFilePath는 .md 파일의 주소입니다.

    // Markdown 파일을 가져오기 위한 비동기 함수를 정의합니다.
    const fetchMarkdown = async () => {
      try {
        const response = await fetch(params.filePath);
        const markdownText = await response.text();
        setMarkdownContent(markdownText);
      } catch (error) {
        console.error('Error fetching markdown:', error);
      }
    };

    // 비동기 함수 호출
    fetchMarkdown();
  }, []); // useEffect의 두 번째 매개변수로 빈 배열을 전달하여 한 번만 실행되도록 설정

  return (
    <Container>
      <Title>
        <h3>{params.title}</h3>
      </Title>
      <Card style={{padding:"20px"}}>
      <ReactMarkdown>{markdownContent}</ReactMarkdown>
      </Card>
    </Container>
  );
}

export default MarkdownPage;
