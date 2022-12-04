import React, { useState } from 'React'
import { Box, Center, Progress, RingProgress, Text, ThemeIcon } from '@mantine/core'
import { useNuiEvent } from '../hooks/useNuiEvent'
import { BiGasPump } from 'react-icons/bi'
import seatbeltIcon from '../img/seatbelt.svg'
import { useConfig } from '../providers/ConfigProvider'


interface Speedo {
	speed: number
	rpm: number
	fuelLevel: number
}

const Speedo: React.FC = () => {
  // Config
  const { config } = useConfig()

	// Visibility
	const [visible, setVisible] = useState<boolean>(false)
	useNuiEvent('toggleSpeedo', (state: boolean) => setVisible(state))

	// Seatbelt
	const [seatbeltColor, setSeatbeltColor] = useState<string>('rgba(200, 0, 0, 0.7)')
	useNuiEvent('setSeatbelt', (state: boolean) =>
	setSeatbeltColor(state === true ? 'rgba(200, 200, 200, 0.9)' : 'rgba(200, 0, 0, 0.7)')
	)

	// ProgressBars states values
	const [speed, setSpeed] = useState<number>(0)
	const [rpm, setRpm] = useState<number>(0)
	const [fuelLevel, setFuelLevel] = useState<number>(0)
	const [fuelLevelColor, setFuelLevelColor] = useState<string>('red')

	const getColor = (value: number, color:string) => {
		if (value > 10) { return color } else { return 'orange' }
	}

	// const speedoMetrics = "kmh" // Set Mph here if needed

	// Set values from client script
	useNuiEvent('setSpeedo', (data: Speedo) => {
		if (!visible) {setVisible(true)}
		setSpeed(data.speed)
		setRpm((data.rpm*100)/1)
		setFuelLevel(data.fuelLevel)
		setFuelLevelColor(getColor(data.fuelLevel, 'gray.4'))
	})

	const getRpmColor = (value: number) => {
		if (value < 45) {
			return 'teal'
		} else if (value < 60) {
			return 'green'
		} else if (value < 85) {
			return 'yellow'
		} else if (value < 95) {
			return 'orange'
		} else {
			return 'red'
		}
	}

	return (
		<>
		{visible && <>
      <Center>
        <Box
          style={{ position: 'fixed', bottom: '7vh', width: '200px', height: '80px', marginTop: '-10vh', backgroundColor: 'rgba(0, 0, 0, 0.5)', borderRadius: '0.7vh', justifyContent: 'center' }}
        >
          {/* RPM */}
          <Progress
            value={rpm}
            color={getRpmColor(rpm)}
            style={{ margin: '7px' }}
          />

          {/* SEATBELT */}
          <div style={{ position: 'relative', margin: '5px', float: 'left' }}>
            <img
              src={seatbeltIcon}
              alt="seatbeltIcon"
              style={{ margin: '5px', marginTop: '7px', width: '30px', fill: seatbeltColor, backgroundColor: seatbeltColor, borderRadius: '7px' }}
            />
          </div>

          {/* SPEED */}
          <div style={{ position: 'absolute', marginLeft: '80px' }}>
            <Center>
              <Text
                color='gray.4'
                size={20}
                weight={800}
                style={{ marginTop: '-2px' }}
              >
                {speed}
              </Text>
            </Center>
            <Center>
              <Text
                color='gray.4'
                size='sm'
                weight={800}
                style={{ marginBottom: '-10px' }}
              >
                { config.speedoMetrics === 'kmh' ? 'Km/h' : 'Mph' }
              </Text>
            </Center>
          </div>

          {/* FUEL */}
          <div style={{ position: 'relative', margin: '5px', float: 'right' }}>
            {fuelLevel !== undefined && <RingProgress sections={[{ value: fuelLevel, color: fuelLevelColor }]} thickness={6/1.2} size={55/1.2} roundCaps
              label={
                <Center>
                <ThemeIcon color={fuelLevelColor} variant='light' radius='xl' size={44/1.2}>
                <BiGasPump size={23} />
                </ThemeIcon>
                </Center>
              }
            />}
          </div>
        </Box>
      </Center>
    </>}
  </>
  )
}

export default Speedo
