import React, { useState, useEffect } from "react";
import { Box, Center, Progress, RingProgress, Text, ThemeIcon } from "@mantine/core";
import { BiGasPump, BiBattery } from "react-icons/bi";
import { useNuiEvent } from "../hooks/useNuiEvent";
import seatbeltIcon from "../img/seatbelt.svg";
import config from "../../../config.json";

interface SpeedoData {
  speed: number;
  rpm: number;
  fuelLevel: number;
  electric: boolean;
}

const Speedo: React.FC = () => {
  const [visible, setVisible] = useState(false);
  const [seatbeltColor, setSeatbeltColor] = useState("rgba(200, 0, 0, 0.7)");
  const [speed, setSpeed] = useState(0);
  const [rpm, setRpm] = useState(0);
  const [fuelLevel, setFuelLevel] = useState(0);
  const [fuelLevelColor, setFuelLevelColor] = useState("red");
  const [electric, setElectric] = useState(false);

  const animate = (start: number, end: number, set: (value: number) => void, duration: number) => {
    const increment = (end - start) / (duration / 10);
    let current = start;

    const update = () => {
      current += increment;
      set(Math.round(current));

      if ((increment > 0 && current < end) || (increment < 0 && current > end)) {
        requestAnimationFrame(update);
      }
    };

    update();
  };

  const getColor = (value: number, color: string) => (value > 10 ? color : "orange");

  const getRpmColor = (value: number) => {
    switch (true) {
      case value < 45:
        return "teal";
      case value < 60:
        return "green";
      case value < 85:
        return "yellow";
      case value < 95:
        return "orange";
      default:
        return "red";
    }
  };

  const updateFuelLevelColor = () => {
    const fuelLevelColor = getColor(fuelLevel, "gray.4");
    setFuelLevelColor(fuelLevelColor);
  };

  const handleToggleSpeedo = (state: boolean) => setVisible(state);
  const handleSetSeatbelt = (state: boolean) =>
    setSeatbeltColor(state ? "rgba(200, 200, 200, 0.9)" : "rgba(200, 0, 0, 0.7)");
  const handleSetSpeedo = (data: SpeedoData) => {
    if (!visible) {
      setVisible(true);
    }

    animate(speed, data.speed, setSpeed, 500);
    animate(rpm, (data.rpm * 100) / 1, setRpm, 500);

    setFuelLevel(data.fuelLevel);
    setElectric(data.electric);
  };

  useNuiEvent("toggleSpeedo", handleToggleSpeedo);
  useNuiEvent("setSeatbelt", handleSetSeatbelt);
  useNuiEvent("setSpeedo", handleSetSpeedo);

  useEffect(updateFuelLevelColor, [config.speedoMetrics, fuelLevel]);

  return (
    <>
      {visible && (
        <>
          <Center>
            <Box
              style={{
                position: "fixed",
                bottom: "7vh",
                width: "200px",
                height: "80px",
                marginTop: "-10vh",
                backgroundColor: "rgba(0, 0, 0, 0.5)",
                borderRadius: "0.7vh",
                justifyContent: "center",
              }}
            >
              <Progress
                value={rpm}
                color={getRpmColor(rpm)}
                style={{ margin: "7px" }}
              />

              <div
                style={{ position: "relative", margin: "5px", float: "left" }}
              >
                <img
                  src={seatbeltIcon}
                  alt="seatbeltIcon"
                  style={{
                    margin: "5px",
                    marginTop: "7px",
                    width: "30px",
                    fill: seatbeltColor,
                    backgroundColor: seatbeltColor,
                    borderRadius: "7px",
                  }}
                />
              </div>

              <div style={{ position: "absolute", marginLeft: "80px" }}>
                <Center>
                  <Text
                    color="gray.4"
                    size={20}
                    weight={800}
                    style={{ marginTop: "-2px" }}
                  >
                    {speed}
                  </Text>
                </Center>
                <Center>
                  <Text
                    color="gray.4"
                    size="sm"
                    weight={800}
                    style={{ marginBottom: "-10px" }}
                  >
                    {config.speedoMetrics === "kmh" ? "Km/h" : "Mph"}
                  </Text>
                </Center>
              </div>

              <div
                style={{ position: "relative", margin: "5px", float: "right" }}
              >
                {fuelLevel !== undefined && (
                  <RingProgress
                    sections={[{ value: fuelLevel, color: fuelLevelColor }]}
                    thickness={6 / 1.2}
                    size={55 / 1.2}
                    roundCaps
                    label={
                      <Center>
                        <ThemeIcon
                          color={fuelLevelColor}
                          variant="light"
                          radius="xl"
                          size={44 / 1.2}
                        >
                          {electric ? (
                            <BiBattery size={23} />
                          ) : (
                            <BiGasPump size={23} />
                          )}
                        </ThemeIcon>
                      </Center>
                    }
                  />
                )}
              </div>
            </Box>
          </Center>
        </>
      )}
    </>
  );
};

export default Speedo;
