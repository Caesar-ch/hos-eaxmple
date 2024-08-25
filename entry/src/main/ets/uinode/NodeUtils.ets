import { NodeController } from '@kit.ArkUI';




export  class NodeUtils{


  static readonly VIDEO="video"
  static readonly WEB="web"

  static readonly PLAYTIME="playTime"
  static readonly STARTTIME="starttime"
  static readonly nodeMap: Map<string, NodeController | undefined> = new Map();



}