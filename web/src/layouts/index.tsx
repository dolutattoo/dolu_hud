import React, { useState } from 'React'
import { Center, Group, RingProgress, ThemeIcon } from '@mantine/core'
import { useNuiEvent } from '../hooks/useNuiEvent'
import { fetchNui } from '../utils/fetchNui'
import { BiBrain, BiHeart, BiMicrophone, BiShield } from 'react-icons/bi'
import { TbDroplet, TbGlass, TbLungs, TbMeat, TbRadio } from 'react-icons/tb'
import { IoSkullOutline } from 'react-icons/io5'
import Config from '../../../config.json'

interface StatusProps {
  voiceLevel: number
  health: number
  armour: number
  hunger: number
  thirst: number
  stress: number
  oxygen: number
  drunk: number
}

const Hud: React.FC = () => {
  // Visibility
  const [visible, setVisible] = useState<boolean>(false)
  useNuiEvent('toggleVisibility', (value: boolean) => setVisible(value))

  // ProgressBars states values
  const [isTalkingRadio, setTalkingRadio] = useState<number>(0)
  const [voiceLevel, setVoiceLevel] = useState<number>(0)
  const [health, setHealth] = useState<number>(0)
  const [armour, setArmour] = useState<number>(0)
  const [hunger, setHunger] = useState<number>(Config.status.hunger.default)
  const [thirst, setThirst] = useState<number>(Config.status.thirst.default)
  const [stress, setStress] = useState<number>(Config.status.stress.default)
  const [drunk, setDrunk] = useState<number>(Config.status.drunk.default)
  const [oxygen, setOxygen] = useState<number>(100)

  // Init values from client script
  useNuiEvent('init', (data: StatusProps) => {
    setVoiceLevel(data.voiceLevel*33.3333)
    setHealth(data.health)
    setArmour(data.armour)
    setHunger(data.hunger)
    setThirst(data.thirst)
    setStress(data.stress)
    setDrunk(data.drunk)
    fetchNui('nuiReady')
    setVisible(true)
  })

  // Colors states
  const [healthColor, setHealthColor] = useState<string>('red')
  const [hungerColor, setHungerColor] = useState<string>(Config.status.hunger.color)
  const [thirstColor, setThirstColor] = useState<string>(Config.status.thirst.color)
  const [oxygenColor, setOxygenColor] = useState<string>(Config.status.thirst.color)

  const getColor = (value: number, color:string) => {
    if (value > 10) { return color } else { return 'red' }
  }

  // Set values from client script
  useNuiEvent('setStatusValue', (data: { statusName: string, value: number }) => {
    if (data.statusName === 'voiceLevel') {
      setVoiceLevel(data.value*33.3333)
    } else if (data.statusName === 'health') {
      setHealth(data.value)
      setHealthColor(getColor(data.value, Config.HealthColor))
    } else if (data.statusName === 'armour') {
      setArmour(data.value)
    } else if (data.statusName === 'hunger') {
      setHunger(data.value)
      setHungerColor(getColor(data.value, Config.status.hunger.color))
    } else if (data.statusName === 'thirst') {
      setThirst(data.value)
      setThirstColor(getColor(data.value, Config.status.thirst.color))
    } else if (data.statusName === 'stress') {
      setStress(data.value)
    } else if (data.statusName === 'drunk') {
      setDrunk(data.value)
    } else if (data.statusName === 'oxygen') {
      setOxygen(data.value)
      setOxygenColor(getColor(data.value, Config.OxygenColor))
    } else if (data.statusName === 'radioState') {
      setTalkingRadio(data.value)
    }
  })

  return (
    <>
        {visible && <Group spacing={0} style={{ position: 'absolute', bottom: '0' }}>

          {/* SPEEDO */}
          {/* {Config.speedo && <Speedo />} */}

          {/* VOICE */}
          {voiceLevel > 0 && <RingProgress sections={[{ value: voiceLevel, color: 'gray.2' }]} thickness={6} size={55} roundCaps
            label={
              <Center>
                <ThemeIcon color='gray.2' variant='light' radius='xl' size={44}>
                  {isTalkingRadio > 0 ? <TbRadio size={23} /> : <BiMicrophone size={23} /> }
                </ThemeIcon>
              </Center>
            }
          />}

          {/* HEALTH */}
          {health !== undefined && <RingProgress sections={[{ value: health, color: healthColor }]} thickness={6} size={55} roundCaps
            label={
              <Center>
                <ThemeIcon color={healthColor} variant='light' radius='xl' size={44}>
                  {health > 0 ? <BiHeart size={23} /> : <IoSkullOutline size={23} />}
                </ThemeIcon>
              </Center>
            }
          />}

          {/* ARMOR */}
          {armour > 0 && <RingProgress sections={[{ value: armour, color: 'blue' }]} thickness={6} size={55} roundCaps
            label={
              <Center>
                <ThemeIcon color='blue' variant='light' radius='xl' size={44}>
                  <BiShield size={23} />
                </ThemeIcon>
              </Center>
            }
          />}

          {/* HUNGER */}
          {(Config.status.hunger.hideOnFull ? hunger < 100 : true) &&
            <RingProgress sections={[{ value: hunger, color: hungerColor }]} thickness={6} size={55} roundCaps
              label={
                <Center>
                  <ThemeIcon color={hungerColor} variant='light' radius='xl' size={44}>
                    <TbMeat size={23} />
                  </ThemeIcon>
                </Center>
              }
            />
          }

          {/* THIRST */}
          {(Config.status.thirst.hideOnFull ? thirst < 100 : true) &&
            <RingProgress sections={[{ value: thirst, color: thirstColor }]} thickness={6} size={55} roundCaps
              label={
                <Center>
                  <ThemeIcon color={thirstColor} variant='light' radius='xl' size={44}>
                    <TbDroplet size={23} />
                  </ThemeIcon>
                </Center>
              }
            />
          }

          {/* STRESS */}
          {(Config.status.stress.hideOnFull ? stress > 0 : true) &&
            <RingProgress sections={[{ value: stress, color: 'orange' }]} thickness={6} size={55} roundCaps
              label={
                <Center>
                  <ThemeIcon color='orange' variant='light' radius='xl' size={44}>
                    <BiBrain size={23} />
                  </ThemeIcon>
                </Center>
              }
            />
          }

          {/* DRUNK */}
          {(Config.status.drunk.hideOnFull ? drunk > 0 : true) &&
            <RingProgress sections={[{ value: drunk, color: 'grape' }]} thickness={6} size={55} roundCaps
              label={
                <Center>
                  <ThemeIcon color='grape' variant='light' radius='xl' size={44}>
                    <TbGlass size={23} />
                  </ThemeIcon>
                </Center>
              }
            />
          }

          {/* OXYGEN */}
          {oxygen < 100 && <RingProgress sections={[{ value: oxygen, color: oxygenColor }]} thickness={6} size={55} roundCaps
            label={
              <Center>
                <ThemeIcon color={oxygenColor} variant='light' radius='xl' size={44}>
                  <TbLungs size={23} />
                </ThemeIcon>
              </Center>
            }
          />}

        </Group>}
    </>
  )
}

export default Hud