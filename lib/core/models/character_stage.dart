/// Character evolution stages tied to streak length.
///
/// Each stage represents a visual evolution of the user's avatar
/// as their recovery streak grows.
enum CharacterStage {
  sprout, // 0 days — starting state
  ember, // 1-6 days — gaining energy
  flame, // 7-13 days — growing stronger
  blaze, // 14-29 days — burning bright
  phoenix, // 30-59 days — reborn
  nova, // 60-89 days — radiating power
  cosmos, // 90+ days — transcendent
}
