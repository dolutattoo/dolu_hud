import React, { useState } from 'React'
import { Center, Group, RingProgress, Text, ThemeIcon } from '@mantine/core'
import { useNuiEvent } from '../hooks/useNuiEvent'
import Config from '../../../config.json'

const Speedo: React.FC = () => {
  // Visibility
  const [visible, setVisible] = useState<boolean>(false)
  useNuiEvent('toggleSpeedo', (state: boolean) => setVisible(state))

  // ProgressBars states values
  const [speed, setSpeed] = useState<number>(0)
  const [gear, setGear] = useState<number>(0)
  const [rpm, setRpm] = useState<number>(0)

  // Set values from client script
  useNuiEvent('setSpeedo', (data: {speed: number, gear:number , rpm: number}) => {
    setSpeed(data.speed)
    setGear(data.gear)
    setRpm(data.rpm)
  })

  const getRpmColor = (value: number) => {
    if (value < 50) {
      return 'teal'
    } else if (value < 75) {
      return 'blue'
    } else if (value < 90) {
      return 'yellow'
    } else {
      return 'orange'
    }
  }

  return (
    <>
        {visible && <Group spacing={0} style={{ position: 'absolute', bottom: '0' }}>
          {/* SPEED */}
          <RingProgress sections={[{ value: (speed*100)/300, color: Config.speedColor }]} thickness={6} size={55} roundCaps
            label={
              <Center>
                <ThemeIcon color={Config.speedColor} variant='light' radius='xl' size={44}>
                  <Text color='gray.4' size='md' weight={600} >{speed}</Text>
                </ThemeIcon>
              </Center>
            }
          />

          {/* RPM */}
          <RingProgress sections={[{ value: (rpm*100)/1, color: getRpmColor((rpm*100)/1) }]} thickness={6} size={55} roundCaps
            label={
              <Center>
                <ThemeIcon color='indigo' variant='light' radius='xl' size={44}>
                  <Text color='gray.4' size='md' weight={600} >{gear}</Text>
                </ThemeIcon>
              </Center>
            }
          />
        </Group>}
    </>
  )
}

export default Speedo