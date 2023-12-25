import {BrowserRouter, Routes, Route, Link} from "react-router-dom";
import styled from "styled-components";
import Home from "./pages/Home";
import DemoVideo from "./pages/DemoVideo";
import Screenshots from "./pages/Screenshots";

function Router() {
    return <BrowserRouter basename={process.env.PUBLIC_URL}>
    <Routes>
        <Route path={`/`} element = {<Home/>}/>
        <Route path={`/home`} element={<Home/>}/>
        <Route path={`/screenshots`} element = {<Screenshots/>}/>
        <Route path={`/video`} element = {<DemoVideo/>}/>
    </Routes>
    </BrowserRouter>
}
export default Router;