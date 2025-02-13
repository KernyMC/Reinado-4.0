import React, { useContext, useEffect, useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import Menu from "../components/Menu";
import Edit from "../img/edit.png";
import Delete from "../img/delete.png";
import axios from "axios";
import moment from "moment";
import "moment/locale/es";
import ReactQuill from 'react-quill';
import 'react-quill/dist/quill.snow.css';
import { AuthContext } from "../context/authContext";
import DOMPurify from "isomorphic-dompurify";
import { API_BASE_URL } from "./ip";

const Single = () => {
  const [value, setValue] = useState('');
  const [post, setPost] = useState({});
  // const [comment, setComment] = useState({});
  const location = useLocation();
  const navigate = useNavigate();
  const [listaComent, setListaComent] = useState([]);

  const postId = location.pathname.split("/")[2];

  const { currentUser } = useContext(AuthContext);
  moment.locale("es");

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await axios.get(`${API_BASE_URL}/posts/${postId}`);
        setPost(res.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, [postId]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await axios.get(`${API_BASE_URL}/coment/${postId}`);
        //console.log(res.data);
        //setComment(res.data);
        setListaComent(res.data);
        //console.log(listaComent);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, [postId]);

  const handleDelete = async () => {
    try {
      await axios.delete(`${API_BASE_URL}/posts/${postId}`);
      navigate("/");
    } catch (err) {
      console.log(err);
    }
  };

  const handleClick1 = async e => {
    e.preventDefault()

    try {
      await axios.post(`/coment/`, {

        coment: value,
        date: moment(Date.now()).format("YYYY-MM-DD HH:mm:ss"),
        pid: postId,
      });
      window.location.reload();

    } catch (err) {
      console.log(err)
    }

  }
  const getText = (html) => {
    const doc = new DOMParser().parseFromString(html, "text/html")
    return doc.body.textContent
  }

  // const handleComment = async (e) => {
  //     e.preventDefault();
  //     const newComment = {
  //         desc: e.target.desc.value,
  //         postId: postId,
  //         username: currentUser.username,
  //         date: new Date()
  //     }
  //     try {
  //         await axios.post("/comments", newComment);
  //         window.location.reload();
  //     } catch (err) {
  //         console.log(err);
  //     }
  // }

  return (
    <div className="single">
      <div className="content">
        <img src={`../upload/${post?.img}`} alt="" />
        <div className="user">
          {post.userImg && <img src={post.userImg} alt="" />}
          <div className="info">
            <span>{post.username}</span>
            <p>Publicado {moment(post.date).fromNow()}</p>
          </div>
          {currentUser.username === post.username && (
            <div className="edit">
              <Link to={`/write?edit=2`} state={post}>
                <img src={Edit} alt="" />
              </Link>
              <img onClick={handleDelete} src={Delete} alt="" />
            </div>
          )}
        </div>
        <h1>{post.title}</h1>
        <p
          dangerouslySetInnerHTML={{
            __html: DOMPurify.sanitize(post.desc),
          }}
        ></p>
        <div className="comments">
          <h2>Comentarios</h2>
          <div className="comment">
            {/* <span>{comment.coment}</span>  */}
            {listaComent.map((val) => {
              return (
                <div className="coment" key={val.id}>
                  <div className="container1">
                    <div className="username">
                      <p>{val.username}</p>
                    </div>
                    <div className="date">
                      {val.date.slice(0, 10)}
                    </div>
                  </div>
                  <p>{getText(val.coment)}</p>
                  <div className="container2">

                  </div>

                </div>
              );
            })}
          </div>
        </div>
        <div className="editorContainer">
          <ReactQuill className="editor" theme="snow" value={value} onChange={setValue} />
        </div>
        <button onClick={handleClick1}>Publicar</button>
      </div>
      <Menu cat={post.cat} />
    </div>
  );
};
export default Single;
