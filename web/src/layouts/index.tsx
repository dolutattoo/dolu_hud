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
  useNuiEvent('init', (data: { health: number, armour: number, voiceLevel: number, status: StatusProps }) => {
    setVoiceLevel(data.voiceLevel*33.3333)
    setHealth(data.health)
    setArmour(data.armour)
    setHunger(data.status.hunger)
    setThirst(data.status.thirst)
    setStress(data.status.stress)
    setDrunk(data.status.drunk)
    fetchNui('nuiReady')
  })

  // Colors states
  const [healthColor, setHealthColor] = useState<string>('red')
  const [hungerColor, setHungerColor] = useState<string>(Config.status.hunger.color)
  const [thirstColor, setThirstColor] = useState<string>(Config.status.thirst.color)
  const [stressColor, setStressColor] = useState<string>(Config.status.stress.color)
  const [drunkColor, setDrunkColor] = useState<string>(Config.status.drunk.color)
  const [oxygenColor, setOxygenColor] = useState<string>(Config.OxygenColor)

  // Set values from client script
  useNuiEvent('setStatusValue', (data: { statusName: string, value: number }) => {
    if (data.statusName === 'voiceLevel') {
      setVoiceLevel(data.value*33.3333)
    } else if (data.statusName === 'health') {
      setHealth(data.value)
      setHealthColor(data.value < 95 ? Config.HealthColor : "red")
    } else if (data.statusName === 'armour') {
      setArmour(data.value)
    } else if (data.statusName === 'hunger') {
      setHunger(data.value)
      setHungerColor(data.value < 95 ? Config.status.hunger.color : "red")
    } else if (data.statusName === 'thirst') {
      setThirst(data.value)
      setThirstColor(data.value < 95 ? Config.status.thirst.color : "red")
    } else if (data.statusName === 'stress') {
      setStress(data.value)
      setStressColor(data.value < 95 ? Config.status.stress.color : "red")
    } else if (data.statusName === 'drunk') {
      setDrunk(data.value)
      setDrunkColor(data.value < 95 ? Config.status.drunk.color : "red")
    } else if (data.statusName === 'oxygen') {
      setOxygen(data.value)
      setOxygenColor(data.value > 10 ? Config.OxygenColor : "red")
    } else if (data.statusName === 'radioState') {
      setTalkingRadio(data.value)
    }
  })

  return (
    <>
        {visible && <Group spacing={0} style={{ position: 'absolute', bottom: '0' }}>
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
          {hunger > 0 &&
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
          {thirst > 0 &&
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
          {stress > 0 &&
            <RingProgress sections={[{ value: stress, color: stressColor }]} thickness={6} size={55} roundCaps
              label={
                <Center>
                  <ThemeIcon color={stressColor} variant='light' radius='xl' size={44}>
                    <BiBrain size={23} />
                  </ThemeIcon>
                </Center>
              }
            />
          }

          {/* DRUNK */}
          {drunk > 0 &&
            <RingProgress sections={[{ value: drunk, color: drunkColor }]} thickness={6} size={55} roundCaps
              label={
                <Center>
                  <ThemeIcon color={drunkColor} variant='light' radius='xl' size={44}>
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