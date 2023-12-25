import {BrowserRouter, Routes, Route, Link} from "react-router-dom";
import styled from "styled-components";
import Home from "./pages/Home";
import App from "./App";
import Algorithm from "./pages/Algorithm";
import DemoVideo from "./pages/DemoVideo";
import Screenshots from "./pages/Screenshots";
import Server from "./pages/Server";

function Router() {
    return <BrowserRouter basename={process.env.PUBLIC_URL}>
    <Routes>
        <Route path={`/`} element = {<Home/>}/>
        <Route path={`/home`} element={<Home/>}/>
        <Route path={`/screenshots`} element = {<Screenshots/>}/>
        <Route path={`/demovideo`} element = {<DemoVideo/>}/>
        <Route path={`/algorithm`} element = {<Algorithm/>}/>
        <Route path={`/app`} element = {<App/>}/>
        <Route path={`/server`} element = {<Server/>}/>
    </Routes>
    </BrowserRouter>
}
export default Router;