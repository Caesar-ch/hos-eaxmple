




export class VideoData {
  constructor(videoSrc?: Resource[], url?: string, startTime?: number,index?:number) {
    this.videoSrc = videoSrc
    this.startTime = startTime;
    this.videoUrl = url
    this.index =index
  }

  index?:number=0
  startTime?: number = 0
  playTime?:number=0
  videoUrl?: string = ""
  videoSrc?: Resource[] = []

  controller: VideoController = new VideoController()

  getVideoUrl():ResourceStr{
    if(this.videoUrl!=undefined){
      return this.videoUrl
    }
    if(this.videoSrc!=undefined){
      return this.videoSrc[this.index!!]
    }

    return ""
  }

}