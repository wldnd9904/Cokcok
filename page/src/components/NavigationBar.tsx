import Container from 'react-bootstrap/Container';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import NavDropdown from 'react-bootstrap/NavDropdown';

function NavigationBar() {
  return (
    <Navbar expand="lg" className="bg-body-tertiary">
      <Container>
        <Navbar.Brand href="/home" style={{"color":"#65C97A", "fontWeight":"bold"}}>COKCOK</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="me-auto">
            <Nav.Link href="/home">콕콕 소개</Nav.Link>
            <Nav.Link href="/screenshots">스크린샷</Nav.Link>
            <Nav.Link href="/video">데모 영상</Nav.Link>
            <NavDropdown title="상세 내용" id="basic-nav-dropdown">
              <NavDropdown.Item href="/algorithm">알고리즘</NavDropdown.Item>
              <NavDropdown.Item href="/app">앱</NavDropdown.Item>
              <NavDropdown.Item href="/server">서버</NavDropdown.Item>
            </NavDropdown>
            <NavDropdown title="Github" id="basic-nav-dropdown">
              <NavDropdown.Item href="https://github.com/rkdthdah/cokcok_data_core">알고리즘</NavDropdown.Item>
              <NavDropdown.Item href="https://github.com/wldnd9904/Cokcok">앱</NavDropdown.Item>
              <NavDropdown.Item href="https://github.com/straipe/cokcok">서버</NavDropdown.Item>
            </NavDropdown>
          </Nav>
        </Navbar.Collapse>
      </Container>
    </Navbar>
  );
}

export default NavigationBar;