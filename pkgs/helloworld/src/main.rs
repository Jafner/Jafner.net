pub fn main() {
// Print all x,y pair coordinates on a 2D plane from [-127,-127] to [+127,+127]
  let mut coord_x: i8 = -127;
  'enumerate_x: loop {
    let mut coord_y: i8 = -127;
    'enumerate_y: loop {
      println!("[{coord_x},{coord_y}]");
      if coord_y == 127 {
        break 'enumerate_y;
      }
      coord_y += 1;
    }
    if coord_x == 127 {
      break 'enumerate_x;
    }
    coord_x += 1;
  }
}
