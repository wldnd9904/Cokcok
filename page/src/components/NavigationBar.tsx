import Container from 'react-bootstrap/Container';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import NavDropdown from 'react-bootstrap/NavDropdown';
import { BrowserRouter } from 'react-router-dom';

function NavigationBar() {
  return (
    <Navbar expand="lg" className="bg-body-tertiary">
      <Container>
        <Navbar.Brand href="/Cokcok/#/home" style={{"color":"#65C97A", "fontWeight":"bold"}}>COKCOK</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="me-auto">
            <Nav.Link href="/Cokcok/#/home">콕콕 소개</Nav.Link>
            <Nav.Link href="/Cokcok/#/screenshots">스크린샷</Nav.Link>
            <Nav.Link href="/Cokcok/#/video">데모 영상</Nav.Link>
            <NavDropdown title="상세 내용" id="basic-nav-dropdown">
              <NavDropdown.Item href="/Cokcok/#/algorithm">알고리즘</NavDropdown.Item>
              <NavDropdown.Item href="/Cokcok/#/app">앱</NavDropdown.Item>
              <NavDropdown.Item href="/Cokcok/#/server">서버</NavDropdown.Item>
            </NavDropdown>
            <Nav.Link href="/Cokcok/#/ksc2023">한국정보과학회 KSC 2023</Nav.Link>
          </Nav>
        </Navbar.Collapse>
      </Container>
    </Navbar>
  );
}

export default NavigationBar;