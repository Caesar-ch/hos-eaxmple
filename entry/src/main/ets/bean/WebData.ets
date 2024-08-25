export class WebData {
  constructor(startTime: number, url: string) {
    this.startTime = startTime;
    this.url = url
  }

  startTime: number = 0
  url: string = ""
}