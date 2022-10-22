import { Box, createStyles } from '@mantine/core'
import Hud from './layouts'

const useStyles = createStyles((theme) => ({
  status: {
    width: '100%',
    height: '100%',
    display: 'flex',
    justifyContent: 'center'
  },
  speedo: {
    width: '100%',
    height: '100%',
    display: 'flex',
    justifyContent: 'center'
  }
}))

const App: React.FC = () => {
  const { classes } = useStyles()

  return (
    <>
      <Box className={classes.status}>
        <Hud />
      </Box>
    </>
  )
}

export default App
