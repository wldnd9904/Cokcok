// src/components/ImageSlider.tsx

import React, { useState, useEffect } from 'react';
import { Carousel, Button } from 'react-bootstrap';

interface ImageSliderProps {
  images: string[];
  labels: string[];
}

const ImageSlider: React.FC<ImageSliderProps> = ({ images, labels }) => {
  const [index, setIndex] = useState(0);

  const handleSelect = (selectedIndex: number) => {
    setIndex(selectedIndex);
  };

  const handlePrev = () => {
    setIndex(index === 0 ? images.length - 1 : index - 1);
  };

  const handleNext = () => {
    setIndex(index === images.length - 1 ? 0 : index + 1);
  };


  return (
    <div style={{ backgroundColor: 'black', height:'400px', width:'100%' }}>
      <Carousel activeIndex={index} onSelect={handleSelect} interval={10000}>
        {images.map((image, i) => (
          <Carousel.Item key={i}>
            <img
              className="d-block w-100"
              src={image}
              alt={`${labels[i]}`}
              style={{height:"400px",objectFit:"contain",scale:"0.9"}}
            />
            <Carousel.Caption>
              <h1 style={{ color: 'white', textShadow: '0px 0px 5px black' }}>{labels[i]}</h1>
            </Carousel.Caption>
          </Carousel.Item>
        ))}
      </Carousel>
    </div>
  );
};

export default ImageSlider;
