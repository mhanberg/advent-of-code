advent_of_code::solution!(1);
use regex::{Captures, Regex};

pub fn part_one(input: &str) -> Option<i32> {
    Some(
        input
            .split("\n")
            .filter(|line| line.len() > 0)
            .map(|line| -> String {
                let digits: Vec<char> = line
                    .chars()
                    .filter(|string| -> bool {
                        return string.is_ascii_digit();
                    })
                    .collect();

                let first = digits.first().unwrap().clone();
                let last = digits.last().unwrap().clone();
                format!("{}{}", first, last)
            })
            .map(|digit| -> i32 {
                return digit.to_string().parse::<i32>().unwrap();
            })
            .sum(),
    )
}

pub fn part_two(input: &str) -> Option<i32> {
    let left =
        Regex::new(r"(1|2|3|4|5|6|7|8|9|one|two|three|four|five|six|seven|eight|nine)").unwrap();
    let right =
        Regex::new(r"(enin|thgie|neves|xis|evif|ruof|eerht|owt|eno|9|8|7|6|5|4|3|2|1)").unwrap();
    let conv = Regex::new(r"(one|two|three|four|five|six|seven|eight|nine)").unwrap();

    Some(
        input
            .split("\n")
            .filter(|line| line.len() > 0)
            .map(|line| -> i32 {
                let first = left.find(line).unwrap().as_str();
                dbg!(first);
                let reversed: String = line.chars().rev().collect();
                let last = right
                    .find(&reversed)
                    .unwrap()
                    .as_str()
                    .chars()
                    .rev()
                    .collect::<String>();
                dbg!(last.clone());
                let replacer = |caps: &Captures| match &caps[0] {
                    "one" => "1",
                    "two" => "2",
                    "three" => "3",
                    "four" => "4",
                    "five" => "5",
                    "six" => "6",
                    "seven" => "7",
                    "eight" => "8",
                    "nine" => "9",
                    _ => panic!(),
                };
                format!("{}{}", conv.replace(first, replacer), conv.replace(&last, replacer)).parse::<i32>().unwrap()
            })
            .sum(),
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    // #[test]
    // fn test_part_one() {
    //     let result = part_one(&advent_of_code::template::read_file("examples", DAY));
    //     assert_eq!(result, Some(142));
    // }

    #[test]
    fn test_part_two() {
        let result = part_two(&advent_of_code::template::read_file("examples", DAY));
        assert_eq!(result, Some(281));
    }
}
