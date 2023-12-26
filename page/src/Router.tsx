import {BrowserRouter, Routes, Route, Link} from "react-router-dom";
import styled from "styled-components";
import Home from "./pages/Home";
import DemoVideo from "./pages/DemoVideo";
import Screenshots from "./pages/Screenshots";
import MarkdownPage from "./pages/MarkdownPage";

function Router() {
    return <BrowserRouter basename={process.env.PUBLIC_URL}>
    <Routes>
        <Route path={`/`} element = {<Home/>}/>
        <Route path={`/home`} element={<Home/>}/>
        <Route path={`/screenshots`} element = {<Screenshots/>}/>
        <Route path={`/video`} element = {<DemoVideo/>}/>
        <Route path={`/algorithm`} element={<MarkdownPage title="알고리즘" filePath="https://raw.githubusercontent.com/rkdthdah/cokcok_data_core/main/README.md"/>}/>
        <Route path={`/app`} element = {<MarkdownPage title="앱" filePath="https://raw.githubusercontent.com/wldnd9904/Cokcok/main/README.md"/>}/>
        <Route path={`/server`} element = {<MarkdownPage title="서버" filePath=""/>}/>
    </Routes>
    </BrowserRouter>
}
export default Router;