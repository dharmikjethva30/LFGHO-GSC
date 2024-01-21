import "./navbar.css"
import logo from "../assets/logo.png"
import {ConnectKitButton} from "connectkit"

export default function Navbar() {
  return (
    <div className="navbar">
        <div className="logo">
        <img src={logo}/>
        </div>
        <ConnectKitButton />
    </div>
  )
}
