import {BrowserRouter, Routes, Route, Link} from "react-router-dom";
import styled from "styled-components";
import Home from "./pages/Home";
import DemoVideo from "./pages/DemoVideo";
import Screenshots from "./pages/Screenshots";
import MarkdownPage from "./pages/MarkdownPage";
import Nonmun from "./pages/Nonmun";

function Router() {
    return <BrowserRouter basename={process.env.PUBLIC_URL}>
    <Routes>
        <Route path={`/`} element = {<Home/>}/>
        <Route path={`/home`} element={<Home/>}/>
        <Route path={`/screenshots`} element = {<Screenshots/>}/>
        <Route path={`/video`} element = {<DemoVideo/>}/>
        <Route path={`/ksc2023`} element = {<Nonmun/>}/>
        <Route path={`/algorithm`} element={
            <MarkdownPage 
                title="알고리즘" 
                filePath="https://raw.githubusercontent.com/rkdthdah/cokcok_data_core/main/README.md" 
                githubPath="https://github.com/rkdthdah/cokcok_data_core"/>}/>
        <Route path={`/app`} element = {
            <MarkdownPage 
                title="앱" 
                filePath="https://raw.githubusercontent.com/wldnd9904/Cokcok/main/README.md" 
                githubPath="https://github.com/wldnd9904/Cokcok"/>}/>
        <Route path={`/server`} element = {
            <MarkdownPage 
                title="서버" 
                filePath="https://raw.githubusercontent.com/straipe/cokcok/main/README.md" 
                githubPath="https://github.com/straipe/cokcok"/>}/>
    </Routes>
    </BrowserRouter>
}
export default Router;