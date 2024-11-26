fn main() {
    let min = std::i8::MIN;
    println!(" min+1:  {}", (min + 1)      );
    println!("|min+1|: {}", (min + 1).abs());
    println!(" min:    {}",  min           );
    println!("|min|:   {}",  min     .abs());
}