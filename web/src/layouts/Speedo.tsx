import React, { useState, useEffect } from "react";
import { Box, Center, Progress, RingProgress, Text, ThemeIcon } from "@mantine/core";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { BiGasPump, BiBattery } from "react-icons/bi";
import seatbeltIcon from "../img/seatbelt.svg";
import config from "../../../config.json";

interface Speedo {
  speed: number;
  rpm: number;
  fuelLevel: number;
  electric: boolean;
}

const Speedo: React.FC = () => {
  const [visible, setVisible] = useState<boolean>(false);
  const [seatbeltColor, setSeatbeltColor] = useState<string>("rgba(200, 0, 0, 0.7)");
  const [speed, setSpeed] = useState<number>(0);
  const [rpm, setRpm] = useState<number>(0);
  const [fuelLevel, setFuelLevel] = useState<number>(0);
  const [fuelLevelColor, setFuelLevelColor] = useState<string>("red");
  const [electric, setElectric] = useState<boolean>(false);

  const getColor = (value: number, color: string): string => (value > 10 ? color : "orange");

  const animateSpeed = (targetSpeed: number, duration: number) => {
    const startSpeed = speed;
    const increment = (targetSpeed - startSpeed) / (duration / 10);
    let currentSpeed = startSpeed;

    const updateSpeed = () => {
      currentSpeed += increment;
      setSpeed(Math.round(currentSpeed));

      if ((increment > 0 && currentSpeed < targetSpeed) || (increment < 0 && currentSpeed > targetSpeed)) {
        requestAnimationFrame(updateSpeed);
      }
    };

    updateSpeed();
  };

  const animateRpm = (targetRpm: number, duration: number) => {
    const startRpm = rpm;
    const increment = (targetRpm - startRpm) / (duration / 10);
    let currentRpm = startRpm;

    const updateRpm = () => {
      currentRpm += increment;
      setRpm(Math.round(currentRpm));

      if ((increment > 0 && currentRpm < targetRpm) || (increment < 0 && currentRpm > targetRpm)) {
        requestAnimationFrame(updateRpm);
      }
    };

    updateRpm();
  };

  useNuiEvent("toggleSpeedo", (state: boolean) => setVisible(state));
  useNuiEvent("setSeatbelt", (state: boolean) =>
    setSeatbeltColor(state ? "rgba(200, 200, 200, 0.9)" : "rgba(200, 0, 0, 0.7)")
  );
  useNuiEvent("setSpeedo", (data: Speedo) => {
    if (!visible) setVisible(true);

    animateSpeed(data.speed, 500);
    animateRpm((data.rpm * 100) / 1, 500);

    setFuelLevel(data.fuelLevel);
    setFuelLevelColor(getColor(data.fuelLevel, "gray.4"));
    setElectric(data.electric);
  });

  const getRpmColor = (value: number): string => {
    const lookupTable: { [key: number]: string } = {
      0: "teal",
      45: "green",
      60: "yellow",
      85: "orange",
      95: "red",
    };

    const sortedKeys = Object.keys(lookupTable)
      .map(Number)
      .sort((a, b) => a - b);

    for (let i = 0; i < sortedKeys.length; i++) {
      const key = sortedKeys[i];
      if (value < key) {
        return lookupTable[key];
      }
    }

    return "red";
  };

  useEffect(() => {
    const speedoMetrics = config.speedoMetrics === "kmh" ? "Km/h" : "Mph";
    const fuelLevelColor = getColor(fuelLevel, "gray.4");

    setFuelLevelColor(fuelLevelColor);
  }, [config.speedoMetrics, fuelLevel]);

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
              <Progress value={rpm} color={getRpmColor(rpm)} style={{ margin: "7px" }} />

              <div style={{ position: "relative", margin: "5px", float: "left" }}>
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
                  <Text color="gray.4" size={20} weight={800} style={{ marginTop: "-2px" }}>
                    {speed}
                  </Text>
                </Center>
                <Center>
                  <Text color="gray.4" size="sm" weight={800} style={{ marginBottom: "-10px" }}>
                    {config.speedoMetrics === "kmh" ? "Km/h" : "Mph"}
                  </Text>
                </Center>
              </div>

              <div style={{ position: "relative", margin: "5px", float: "right" }}>
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
                          {electric ? <BiBattery size={23} /> : <BiGasPump size={23} />}
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
