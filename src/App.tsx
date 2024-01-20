import "./App.css";
import Navbar from "./components/Navbar";
import { WagmiConfig, createConfig } from "wagmi";
import { ConnectKitProvider, getDefaultConfig } from "connectkit";
import ReactSpeedometer from "react-d3-speedometer";
const config = createConfig(
  getDefaultConfig({
    // Required API Keys
    infuraId: "731fac7448b5402c9dd49eb363dcffa3", // or infuraId
    walletConnectProjectId: "25c8361be7eaff8ab7aa9b4abe0c3bc0",

    // Required
    appName: "GSC",

    // Optional
    // appDescription: "Your App Description",
    // appUrl: "https://family.co", // your app's url
    // appIcon: "https://family.co/logo.png", // your app's icon, no bigger than 1024x1024px (max. 1MB)
  })
);
function App() {
  return (
    <>
      <WagmiConfig config={config}>
        <ConnectKitProvider>
          <div className="home-page">
            <Navbar />
            <div className="hero-section-container">
              <div className="hero-section">
                <div className="gsc-initials">
                  <span>G</span>
                  <span>S</span>
                  <span>C</span>
                </div>
                <div className="gsc-fullform">
                  <span>GHO</span>
                  <span>Safe</span>
                  <span>Credit</span>
                </div>
                <div className="hero-desc">
                  <span>
                  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed hendrerit dictum ullamcorper. In fermentum enim non congue viverra.estibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Donec non neque vel erat molestie aliquet.
                  </span>
                
                </div>
              </div>
              <div className="credit-score-meter">
                <ReactSpeedometer
                  height={500}
                  width={500}
                  maxValue={1000}
                  value={500}
                  ringWidth={100}
                  valueFormat={"d"}
                  customSegmentStops={[0, 200, 400, 600, 800, 1000]}
                  segmentColors={[
                    "#2b2d42",
                    "#8d99ae",
                    "#edf2f4",
                    "#ef233c",
                    "#d90429",
                  ]}
                  // currentValueText={"CREDIT SCORE: 10%"}
                  textColor={"gray"}
                />
              </div>
            </div>
            <div className="button-section">
              <div className="button-container">
                <button className="borrow-button">Borrow</button>
                <button className="borrow-button">History</button>
              </div>
            </div>
          </div>
        </ConnectKitProvider>
      </WagmiConfig>
    </>
  );
}

export default App;
