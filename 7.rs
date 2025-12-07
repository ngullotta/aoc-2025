use std::fs::read_to_string;

fn main() {
    let raw = read_to_string("data/7.txt").unwrap();
    let (first, rest) = raw.split_once('\n').unwrap();
    let mut beams: Vec<u64> = first
        .bytes()
        .map(|b| (b == b'S') as u64)
        .collect();
    let (mut p1, mut p2) = (0, 1);

    rest.lines().for_each(|line| {
        let splits = line.as_bytes();
        for i in 0..beams.len() {
            let b = beams[i];
            if b != 0 && splits[i] == b'^' {
                p1 += 1;
                p2 += b;
                beams[i - 1] += b;
                beams[i + 1] += b;
                beams[i] = 0;
            }
        }
    });

    println!("{p1}\n{p2}");
}